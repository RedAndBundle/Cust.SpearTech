table 80402 "PTE Check Data"
{
    Caption = 'Check Data';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document Number"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Document Number';
        }
        field(2; "External Document No."; Code[35])
        {
            DataClassification = CustomerContent;
            Caption = 'External Document No.';
        }
        field(3; "PDF"; Blob)
        {
            Compressed = true;
            DataClassification = CustomerContent;
        }
        field(4; "Filename"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'File Name';
        }
        field(20; "Client"; Text[250])
        {
            Caption = 'Client';
            DataClassification = SystemMetadata;
        }
        field(21; "TIN SSN"; Text[250])
        {
            Caption = 'TIN/SSN';
            DataClassification = SystemMetadata;
        }
        field(22; "Claim Number"; Text[250])
        {
            Caption = 'Claim Number';
            DataClassification = SystemMetadata;
        }
        field(23; "Claimant Name"; Text[250])
        {
            Caption = 'Claimant Name';
            DataClassification = SystemMetadata;
        }
        field(24; "Loss Date"; Date)
        {
            Caption = 'Loss Date';
            DataClassification = SystemMetadata;
        }
        field(25; "Payment Type"; Text[250])
        {
            Caption = 'Payment Type';
            DataClassification = SystemMetadata;
        }
        field(26; "From Date"; Date)
        {
            Caption = 'From Date';
            DataClassification = SystemMetadata;
        }
        field(27; "Through Date"; Date)
        {
            Caption = 'Through Date';
            DataClassification = SystemMetadata;
        }
        field(28; "Invoice Date"; Date)
        {
            Caption = 'Invoice Date';
            DataClassification = SystemMetadata;
        }
        field(29; "Invoice No."; Code[35])
        {
            Caption = 'Invoice No.';
            DataClassification = SystemMetadata;
        }
        field(30; "Carrier Name 1"; Text[250])
        {
            Caption = 'Carrier Name 1';
            DataClassification = SystemMetadata;
        }
        field(31; "Carrier Name 2"; Text[250])
        {
            Caption = 'Carrier Name 2';
            DataClassification = SystemMetadata;
        }
        field(32; "Comment"; Text[500])
        {
            Caption = 'Comment';
            DataClassification = SystemMetadata;
        }
        field(33; "Department"; Text[100])
        {
            Caption = 'Department';
            DataClassification = SystemMetadata;
        }
        field(34; "Adjuster Name"; Text[100])
        {
            Caption = 'Adjuster Name';
            DataClassification = SystemMetadata;
        }
        field(35; "Adjuster Phone"; Text[100])
        {
            Caption = 'Adjuster Phone';
            DataClassification = SystemMetadata;
        }
        field(36; "Event Number"; Text[100])
        {
            Caption = 'Event Number';
            DataClassification = SystemMetadata;
        }
        field(37; "Control Number"; Text[100])
        {
            Caption = 'Control Number';
            DataClassification = SystemMetadata;
        }
        field(38; "Additional Payee"; Text[100])
        {
            Caption = 'Additional Payee';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; "Document Number")
        {
            Clustered = true;
        }
    }

    procedure DownloadPDF()
    var
        TempBlob: Codeunit "Temp Blob";
        is: InStream;
        os: OutStream;
    begin
        if Filename = 'Click to import...' then
            exit;
        Rec.CalcFields(PDF);
        if not PDF.HasValue then
            exit;

        TempBlob.FromRecord(Rec, Rec.FieldNo(PDF));
        TempBlob.CreateOutStream(os);
        TempBlob.CreateInStream(is);
        DownloadFromStream(is, '', '', '', Filename);
    end;
}