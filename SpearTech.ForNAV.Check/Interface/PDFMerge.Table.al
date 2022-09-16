table 80401 "PTE PDF Merge"
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
        clientFileName: Text;
        TempBlob: Codeunit "Temp Blob";
        is: InStream;
    begin
        clientFileName := StrSubstNo('Check %1.pdf', CurrentDateTime);
        if not FindLast() then
            exit;
        // FindFirst();
        CalcFields(Blob);
        Blob.CreateInStream(is);
        DownloadFromStream(is, '', '', '', clientFileName);

    end;
}