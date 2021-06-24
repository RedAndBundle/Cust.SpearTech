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


    procedure ProcessPaymentInterface(Base64String: Text)
    begin
        CreateVendorLedgerEntry();
        CreatePDF(Base64String);
    end;

    local procedure CreateVendorLedgerEntry()
    var
        GenJnlLn: Record "Gen. Journal Line";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
    begin
        GenJnlLn.Init();
        GenJnlLn."Document No." := "Document No.";
        GenJnlLn."External Document No." := "External Document No.";
        GenJnlLn."Posting Date" := WorkDate(); // TODO What date to use
        GenJnlLn.Description := Description;
        GenJnlLn.Amount := "Amount (USD)";
        GenJnlLn."Account Type" := GenJnlLn."Account Type"::Vendor;
        GenJnlLn."Account No." := "Vendor No.";
        GenJnlLn."Bal. Account Type" := GenJnlLn."Bal. Account Type"::"G/L Account";
        GenJnlLn."Bal. Account No." := GetBalAccountFromVendor();
        // TODO Not sure if Business Central allows a bank... "Bank Account No.";
        // TODO How to map this       GenJnlLn."Payment Method Code" := 
        GenJnlPostLine.RunWithCheck(GenJnlLn);
    end;

    local procedure CreatePDF(Base64String: Text)
    var
        PDFFile: Record "ForNAV File Storage";
        Base64Convert: Codeunit "Base64 Convert";
        OutStr: OutStream;
    begin
        PDFFile.Code := "Document No.";
        PDFFile.Data.CreateOutStream(OutStr);
        OutStr.WriteText(Base64Convert.FromBase64(Base64String));
        PDFFile.Insert();
    end;

    local procedure GetBalAccountFromVendor(): Code[20]
    var
        Vend: Record Vendor;
        VendPstGroup: Record "Vendor Posting Group";
    begin
        Vend.Get("Vendor No.");
        VendPstGroup.Get(Vend."Vendor Posting Group");
        exit(VendPstGroup."Payables Account"); // TODO We probably want some cost account
    end;
}