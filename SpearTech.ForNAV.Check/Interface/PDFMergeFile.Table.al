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

    procedure Zip()
    var
        DataCompression: Codeunit "Data Compression";
        TempBlob: Codeunit "Temp Blob";
        is: InStream;
        os: OutStream;
        clientFileName: Text;
    begin
        DataCompression.CreateZipArchive();
        SetAutoCalcFields(Blob);
        if not FindSet() then
            exit;

        repeat
            Blob.CreateInStream(is);
            if Count = 1 then begin
                DownloadFromStream(is, '', '', '', FileName);
                exit;
            end;

            DataCompression.AddEntry(is, Filename);
        until Next() = 0;

        TempBlob.CreateOutStream(os);
        DataCompression.SaveZipArchive(os);
        TempBlob.CreateInStream(is);
        clientFileName := StrSubstNo('Check Export %1.zip', CurrentDateTime);
        DownloadFromStream(is, '', '', '', clientFileName);
        DataCompression.CloseZipArchive();
    end;

    procedure MergeAndPreview()
    var
        MergePDF: Codeunit "PTE Merge PDF";
        clientFileName: Text;
        is: InStream;
    begin
        clientFileName := StrSubstNo('Check %1.pdf', CurrentDateTime);
        if IsEmpty then begin
            Message('No PDF to merge');
            exit;
        end;

        if Count <> 1 then
            MergePDF.Run(Rec);

        FindFirst();
        CalcFields(Blob);
        Blob.CreateInStream(is);
        DownloadFromStream(is, '', '', '', clientFileName);
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