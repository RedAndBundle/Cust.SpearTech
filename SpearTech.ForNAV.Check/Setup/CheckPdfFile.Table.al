table 80406 "PTE Check PDF File"
{
    DataClassification = CustomerContent;
    Caption = 'Check PDF File';
    Access = Internal;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(2; "Data"; Blob)
        {
            Caption = 'Data';
        }
        field(3; "Filename"; Text[250])
        {
            Caption = 'Filename';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    procedure Download()
    var
        is: InStream;
    begin
        CalcFields("Data");
        if not Data.HasValue then
            exit;

        Data.CreateInStream(is);
        DownloadFromStream(is, '', '', '', Filename);
    end;

    procedure Cleanup()
    begin
        SetRange(SystemCreatedAt, 0DT, CreateDateTime(Today - 7, 0T));
        DeleteAll();
    end;
}