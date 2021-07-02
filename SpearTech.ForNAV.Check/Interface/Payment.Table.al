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
        field(8; "Posting Date"; Date) { DataClassification = SystemMetadata; }

    }

    keys { key(Key1; "Vendor No.") { Clustered = true; } }

    procedure ProcessPaymentInterface(Base64String: Text): Text
    begin
        CreateVendorLedgerEntry();
        CreatePDF(Base64String);
        CreatePaymentJournalLine();
        exit('Vendor Ledger Entries created and Payment Journal prepared in ' + GetPaymentJournalBatch().Name);
    end;

    local procedure CreatePaymentJournalLine()
    var
        x: Report "Suggest Vendor Payments";
        Vendor: Record Vendor;
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine.SetRange("Journal Template Name", GetPaymentJournalBatch()."Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", GetPaymentJournalBatch().Name);
        if GenJnlLine.FindLast() then
            GenJnlLine."Line No." += 10000
        else
            GenJnlLine."Line No." := 10000;

        GenJnlLine.Init;
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
        GenJnlLine."Posting No. Series" := GetPaymentJournalBatch."Posting No. Series";
        GenJnlLine."Journal Template Name" := GetPaymentJournalBatch()."Journal Template Name";
        GenJnlLine."Journal Batch Name" := GetPaymentJournalBatch().Name;
        GenJnlLine."Document No." := "Document No.";
        //         "Document No." := NextDocNo;
        //         IncrementDocumentNo(GenJnlBatch, NextDocNo);
        //     end else
        //         if (TempPaymentBuffer."Vendor No." = OldTempPaymentBuffer."Vendor No.") and
        //            (TempPaymentBuffer."Currency Code" = OldTempPaymentBuffer."Currency Code")
        //         then
        //             "Document No." := OldTempPaymentBuffer."Document No."
        //         else begin
        //             "Document No." := NextDocNo;

        //             IncrementDocumentNo(GenJnlBatch, NextDocNo);

        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;
        GenJnlLine.SetHideValidation(true);
        GenJnlLine."Posting Date" := "Posting Date";
        GenJnlLine.Validate("Account No.", "Vendor No.");
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
        GenJnlLine.Validate("Bal. Account No.", GetBankAccount."No.");
        // "Message to Recipient" := GetMessageToRecipient(SummarizePerVend); TODO Can we use this?
        case "Payment Method" of
            "Payment Method"::Check:
                GenJnlLine."Bank Payment Type" := GenJnlLine."Bank Payment Type"::"Computer Check";
            "Payment Method"::EFT:
                GenJnlLine."Bank Payment Type" := GenJnlLine."Bank Payment Type"::"Electronic Payment";
            "Payment Method"::Void:
                GenJnlLine."Bank Payment Type" := GenJnlLine."Bank Payment Type"::"Manual Check";
        end;
        GenJnlLine.Description := Description;
        GenJnlLine."Source Line No." := GetLastVendorLedgerEntryNo()."Entry No.";
        GenJnlLine.Validate(Amount, "Amount (USD)");
        GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
        GenJnlLine."Applies-to Doc. No." := "Document No.";
        GenJnlLine."Payment Method Code" := GetPaymentMethod();
        GenJnlLine.Insert();
    end;

    local procedure CreateVendorLedgerEntry()
    var
        GenJnlLn: Record "Gen. Journal Line";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
    begin
        GenJnlLn.Init();
        GenJnlLn."Document No." := "Document No.";
        GenJnlLn."Document Type" := GenJnlLn."Document Type"::Invoice;
        GenJnlLn."External Document No." := "External Document No.";
        GenJnlLn."Posting Date" := "Posting Date";
        GenJnlLn.Description := Description;
        GenJnlLn.Amount := -"Amount (USD)";
        GenJnlLn."Account Type" := GenJnlLn."Account Type"::Vendor;
        GenJnlLn."Account No." := "Vendor No.";
        GenJnlLn."Bal. Account Type" := GenJnlLn."Bal. Account Type"::"G/L Account";
        GenJnlLn."Bal. Account No." := GetBalAccountFromVendor();
        // GenJnlLn."Recipient Bank Account" := "Bank Account No.";
        // TODO add external document no
        GenJnlLn."Payment Method Code" := GetPaymentMethod();
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
        // OutStr.WriteText(Base64Convert.FromBase64(Base64String));
        Base64Convert.FromBase64(Base64String, OutStr);
        PDFFile.Filename := "Document No." + '.pdf';
        PDFFile.Insert();
    end;

    local procedure GetBalAccountFromVendor(): Code[20]
    var
        Setup: Record "PTE Spear Technology Setup";
    begin
        Setup.Get();
        exit(Setup."G/L Account No.");
    end;

    local procedure GetPaymentMethod(): Code[10]
    var
        Setup: Record "PTE Spear Technology Setup";
    begin
        Setup.Get();
        case "Payment Method" of
            "Payment Method"::Check:
                exit(Setup."Payment Method (Check)");
            "Payment Method"::EFT:
                exit(Setup."Payment Method (EFT)");
            "Payment Method"::Void:
                exit(Setup."Payment Method (Void)");
        end
    end;

    local procedure GetBankAccount() BankAccount: Record "Bank Account"
    begin
        BankAccount.SetRange("Bank Account No.", "Bank Account No.");
        BankAccount.FindFirst();
    end;

    local procedure GetPaymentJournalBatch() Batch: Record "Gen. Journal Batch"
    begin
        Batch.SetRange("Bal. Account Type", Batch."Bal. Account Type"::"Bank Account");
        Batch.SetRange("Bal. Account No.", GetBankAccount."No.");
        Batch.FindFirst();
    end;

    local procedure GetLastVendorLedgerEntryNo() VendLedEnt: Record "Vendor Ledger Entry";
    begin
        VendLedEnt.SetCurrentKey("Document No.", "Document Type", "Vendor No.");
        VendLedEnt.SetRange("Vendor No.", "Vendor No.");
        VendLedEnt.SetRange("Document No.", "Document No.");
        VendLedEnt.SetRange("Document Type", VendLedEnt."Document Type"::Invoice);
        VendLedEnt.FindFirst();
    end;
}