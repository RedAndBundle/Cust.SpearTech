table 50100 "PTE Payment Interface"
{
    DataClassification = SystemMetadata;
    TableType = Temporary;

    fields
    {
        field(1; "Vendor No."; Code[20]) { DataClassification = SystemMetadata; }
        field(2; "Document No."; Code[20]) { DataClassification = SystemMetadata; }
        field(3; "Payment Method"; Option) { DataClassification = SystemMetadata; OptionMembers = Check,EFT,Void; }
        field(4; "Amount (USD)"; Decimal) { DataClassification = SystemMetadata; }
        field(5; "Bank Account No."; Text[30]) { DataClassification = SystemMetadata; }
        field(6; "External Document No."; Code[35]) { DataClassification = SystemMetadata; }
        field(7; Description; Text[50]) { DataClassification = SystemMetadata; }
    }

    keys { key(Key1; "Vendor No.") { Clustered = true; } }


    procedure ProcessPaymentInterface()
    begin
        CreateVendorLedgerEntry();
        CreatePDF();
    end;

    local procedure CreateVendorLedgerEntry()
    var
        GenJnlLn: Record "Gen. Journal Line";

    begin
        //GenJnlLn.
    end;

    local procedure CreatePDF()
    begin

    end;

}