table 80401 "PTE PDF Merge File"
{
    DataClassification = SystemMetadata;
    Caption = 'PDF Merge';
    TableType = Temporary;

    fields
    {
        field(1; "Primary Key"; Code[20])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(10; Blob; Blob)
        {
            Caption = 'Blob';
            DataClassification = SystemMetadata;
        }
        field(11; Filename; Text[250])
        {
            Caption = 'Filename';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    internal procedure GetFromAppliestoID(AppliestoID: Code[50]): Boolean
    var
        CheckData: Record "PTE Check Data";
        MergePDF: Codeunit "PTE Merge PDF";
    begin
        CheckData.Setrange("Applies-to ID", AppliestoID);
        if not CheckData.FindSet() then
            exit;

        CheckData.SetAutoCalcFields(PDF);
        repeat
            if CheckData.PDF.HasValue then begin
                "Primary Key" := CheckData."Document Number";
                Blob := CheckData.PDF;
                Filename := CheckData."Document Number" + '.pdf';
                Insert();
            end;
        until CheckData.Next() = 0;

        if Count <> 1 then
            MergePDF.Run(Rec);

        exit(FindFirst());
    end;

    procedure Zip()
    var
        CheckPDFFile: Record "PTE Check PDF File";
        DataCompression: Codeunit "Data Compression";
        MergePDF: Codeunit "PTE Merge PDF";
        is: InStream;
        ClientFileName: Text;
    begin
        DataCompression.CreateZipArchive();
        SetAutoCalcFields(Blob);
        if not FindSet() then
            exit;

        repeat
            if Count = 1 then begin
                CheckPDFFile := MergePDF.SaveFromPDFMergeFile(Rec, FileName);
                Page.Run(Page::"PTE Check PDF File", CheckPDFFile);
                exit;
            end;

            Blob.CreateInStream(is);
            DataCompression.AddEntry(is, Filename);
        until Next() = 0;

        ClientFileName := StrSubstNo('Check Export %1.zip', CurrentDateTime);
        CheckPDFFile := MergePDF.SaveFromDataCompression(DataCompression, ClientFileName);
        Page.Run(Page::"PTE Check PDF File", CheckPDFFile);
    end;

    procedure MergeAndPreview()
    var
        CheckPDFFile: Record "PTE Check PDF File";
        MergePDF: Codeunit "PTE Merge PDF";
        ClientFileName: Text;
    begin
        ClientFileName := StrSubstNo('Check %1.pdf', CurrentDateTime);
        if IsEmpty then begin
            Message('No PDF to merge');
            exit;
        end;

        if Count <> 1 then
            MergePDF.Run(Rec);

        CheckPDFFile := MergePDF.SaveFromPDFMergeFile(Rec, ClientFileName);
        Page.Run(Page::"PTE Check PDF File", CheckPDFFile);
    end;

    procedure InsertFromObject(jObject: JsonObject)
    var
        Base64Convert: Codeunit "Base64 Convert";
        OutStr: OutStream;
        jToken: JsonToken;
        EntryNo: Integer;
    begin
        Init();
        if jObject.Get('page', jToken) and (not jToken.AsValue().IsNull) then
            EntryNo := jToken.AsValue().AsInteger()
        else
            EntryNo += 1;

        "Primary Key" := Format(EntryNo);
        Blob.CreateOutStream(OutStr);
        jObject.Get('base64', jToken);
        Base64Convert.FromBase64(jToken.AsValue().AsText(), OutStr);
        Insert();
    end;
}