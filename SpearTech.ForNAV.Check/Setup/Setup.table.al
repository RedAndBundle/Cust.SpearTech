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
            OptionCaption = 'Print,PDF,Zip';
            OptionMembers = Print,PDF,Zip;
        }
    }

    keys { key(pk; "Primary Key") { Clustered = true; } }

}