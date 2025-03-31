codeunit 80404 "PTE Merge PDF"
{
    TableNo = "PTE PDF Merge File";
    Permissions = tabledata "PTE Check PDF File" = RIMD;

    trigger OnRun()
    begin
        Merge(Rec);
    end;

    local procedure Merge(var PDFMergeFile: Record "PTE PDF Merge File")
    var
        Setup: Record "PTE Spear Technology Setup";
        jArray: JsonArray;
        jObject: JsonObject;
        Result: Text;
    begin
        if PDFMergeFile.IsEmpty() then
            exit;

        Setup.Get();
        jArray := GetFilesArray(PDFMergeFile);
        Result := Post(Setup."PDF Merge Webservice", Setup."PDF Merge Key", Format(jArray));

        if not jObject.ReadFrom(Result) then
            exit;

        PDFMergeFile.DeleteAll();
        PDFMergeFile.InsertFromObject(jObject);
    end;

    local procedure GetFilesArray(var PDFMergeFile: Record "PTE PDF Merge File") jArray: JsonArray
    var
        Base64Convert: Codeunit "Base64 Convert";
        InStr: InStream;
        jObject: JsonObject;
        i: Integer;
    begin
        PDFMergeFile.SetAutoCalcFields(Blob);
        if PDFMergeFile.FindSet() then
            repeat
                Clear(jObject);
                i += 1;
                jObject.Add('page', i);
                PDFMergeFile.Blob.CreateInStream(InStr);
                jObject.Add('base64', Base64Convert.ToBase64(InStr));
                jArray.Add(jObject);
            until PDFMergeFile.Next() = 0;
    end;

    procedure Post(Url: Text; ApiKey: Text; Payload: Text) Result: Text
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        Content: HttpContent;
        ContentHeaders: HttpHeaders;
    begin
        Content.WriteFrom(Payload);
        Content.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json');
        if not Client.Post(Url + '?Code=' + ApiKey, Content, Response) then
            Error(CannotConnectErr);

        if not Response.IsSuccessStatusCode then
            Error(WebServiceErr, Response.HttpStatusCode, Response.ReasonPhrase);

        Response.Content.ReadAs(Result);
    end;

    internal procedure SaveFromPDFMergeFile(var PDFMergeFile: Record "PTE PDF Merge File"; ClientFileName: Text) CheckPDFFile: Record "PTE Check PDF File"
    begin
        PDFMergeFile.FindFirst();
        PDFMergeFile.CalcFields(Blob);
        CheckPDFFile.Init();
        CheckPDFFile."Data" := PDFMergeFile.Blob;
        CheckPDFFile."Filename" := clientFileName;
        CheckPDFFile.Insert();
        Commit();
    end;

    internal procedure SaveFromDataCompression(var DataCompression: Codeunit "Data Compression"; ClientFileName: Text) CheckPDFFile: Record "PTE Check PDF File"
    var
        os: OutStream;
    begin
        CheckPDFFile.Init();
        CheckPDFFile."Data".CreateOutStream(os);
        DataCompression.SaveZipArchive(os);
        CheckPDFFile."Filename" := ClientFileName;
        CheckPDFFile.Insert();
        DataCompression.CloseZipArchive();
        Commit();
    end;

    var
        CannotConnectErr: Label 'Cannot connect';
        WebServiceErr: Label 'Web Service error:\\Statuscode: %1\Description: %2', Comment = '%1 = HttpStatusCode %2 = ReasonPhrase';
}