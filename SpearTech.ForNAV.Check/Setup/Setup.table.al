table 80410 "PTE Spear Technology Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[1]) { DataClassification = SystemMetadata; }
        field(10; "Payment Method (Check)"; Code[10]) { DataClassification = CustomerContent; TableRelation = "Payment Method"; }
        field(20; "Payment Method (EFT)"; Code[10]) { DataClassification = CustomerContent; TableRelation = "Payment Method"; }
        field(30; "Payment Method (Void)"; Code[10]) { DataClassification = CustomerContent; TableRelation = "Payment Method"; }
        field(60; "G/L Account No."; Code[20]) { DataClassification = CustomerContent; TableRelation = "G/L Account"; }
        field(70; "Output Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = 'PDF,Zip';
            OptionMembers = PDF,Zip;
        }
        field(80; "PDF Merge Webservice"; Text[100]) { DataClassification = SystemMetadata; }
        field(90; "PDF Merge Key"; Text[100]) { DataClassification = SystemMetadata; ExtendedDatatype = Masked; }
        field(100; "Global Check No."; Boolean) { DataClassification = SystemMetadata; }
        field(105; "Global Last Check No."; Code[20]) { DataClassification = SystemMetadata; }
    }

    keys { key(pk; "Primary Key") { Clustered = true; } }

    procedure TestPDFSetup()
    begin
        case true of
            "Output Type" <> "Output Type"::PDF,
            ("PDF Merge Webservice" <> '') and ("PDF Merge Key" <> ''):
                exit;
        end;

        "PDF Merge Webservice" := 'https://redpdfmethods.azurewebsites.net/api/v1/merge';
        "PDF Merge Key" := 'To2HLw4YT4JavfCc09EeVFj0vA0Nm9XsYGm7uyH5aWfxijDfditV4w==';
        Modify();
    end;

    procedure TestReportSelection()
    var
        ReportSelections: Record "Report Selections";
        NoReportSelectionsErr: Label 'No Report Selections found for PTE Spear Check';
    begin
        ReportSelections.SetRange(Usage, ReportSelections.Usage::"PTE Spear Check");
        if ReportSelections.IsEmpty() then
            Error(NoReportSelectionsErr);
    end;
}