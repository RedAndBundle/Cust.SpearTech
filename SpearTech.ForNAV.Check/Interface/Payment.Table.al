table 80400 "PTE Payment Interface"
{
    DataClassification = SystemMetadata;
    TableType = Temporary;
    Permissions = tabledata "PTE Check Data" = RIMD;

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
        field(9; "Bank No."; Text[30]) { DataClassification = SystemMetadata; }
        field(20; "Client"; Text[250]) { DataClassification = SystemMetadata; }
        field(21; "TIN SSN"; Text[250]) { DataClassification = SystemMetadata; }
        field(22; "Claim Number"; Text[250]) { DataClassification = SystemMetadata; }
        field(23; "Claimant Name"; Text[250]) { DataClassification = SystemMetadata; }
        field(24; "Loss Date"; Date) { DataClassification = SystemMetadata; }
        field(25; "Payment Type"; Text[250]) { DataClassification = SystemMetadata; }
        field(26; "From Date"; Date) { DataClassification = SystemMetadata; }
        field(27; "Through Date"; Date) { DataClassification = SystemMetadata; }
        field(28; "Invoice Date"; Date) { DataClassification = SystemMetadata; }
        field(29; "Invoice No."; Code[35]) { DataClassification = SystemMetadata; }
        field(30; "Carrier Name 1"; Text[250]) { DataClassification = SystemMetadata; }
        field(31; "Carrier Name 2"; Text[250]) { DataClassification = SystemMetadata; }
        field(32; "Comment"; Text[500]) { DataClassification = SystemMetadata; }
        field(33; "Department"; Text[100]) { DataClassification = SystemMetadata; }
        field(34; "Adjuster Name"; Text[100]) { DataClassification = SystemMetadata; }
        field(35; "Adjuster Phone"; Text[100]) { DataClassification = SystemMetadata; }
        field(36; "Event Number"; Text[100]) { DataClassification = SystemMetadata; }
        field(37; "Control Number"; Text[100]) { DataClassification = SystemMetadata; }
        field(38; "Additional Payee"; Text[100]) { DataClassification = SystemMetadata; }
        field(39; "Additional Payee Text"; Text[250]) { DataClassification = SystemMetadata; }
        field(40; "Group Claimant Vendor Checks"; Boolean) { DataClassification = SystemMetadata; }
        field(41; "Claimant Id"; Guid) { DataClassification = SystemMetadata; }
        field(42; "Add. Pay. Name"; Text[50]) { DataClassification = SystemMetadata; }
        field(43; "Add. Pay. Name 2"; Text[50]) { DataClassification = SystemMetadata; }
        field(44; "Add. Pay. Address"; Text[50]) { DataClassification = SystemMetadata; }
        field(45; "Add. Pay. Address 2"; Text[50]) { DataClassification = SystemMetadata; }
        field(46; "Add. Pay. City"; Text[30]) { DataClassification = SystemMetadata; }
        field(47; "Add. Pay. Post Code"; Code[20]) { DataClassification = SystemMetadata; }
        field(48; "Add. Pay. County"; Text[30]) { DataClassification = SystemMetadata; }
        field(49; "Add. Pay. Country/Region Code"; Code[10]) { DataClassification = SystemMetadata; }
    }

    keys { key(Key1; "Vendor No.") { Clustered = true; } }

    procedure ProcessPaymentInterface(Base64String: Text): Text
    begin
        CreateVendorLedgerEntry();
        CreateCheckData(Base64String);
        CreatePaymentJournalLine();
        exit('Vendor Ledger Entries created and Payment Journal prepared in ' + GetPaymentJournalBatch().Name);
    end;

    local procedure CreatePaymentJournalLine()
    var
        GenJnlLine: Record "Gen. Journal Line";
        CheckData: Record "PTE Check Data";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    // p: page 256
    begin
        if SummarizePerVendor() and GetGenJournalLineForVendor(GenJnlLine) then begin
            GenJnlLine.Validate(Amount, GenJnlLine.Amount + "Amount (USD)");
            GenJnlLine.Modify();
        end else begin
            GenJnlLine."Line No." := GetGenJnlLineNo();

            GenJnlLine.Init();
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
            GenJnlLine."Posting No. Series" := GetPaymentJournalBatch()."Posting No. Series";
            GenJnlLine."Journal Template Name" := GetPaymentJournalBatch()."Journal Template Name";
            GenJnlLine."Journal Batch Name" := GetPaymentJournalBatch().Name;
            GenJnlLine."Document No." := "Document No.";

            GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;
            GenJnlLine.SetHideValidation(true);
            GenJnlLine."Posting Date" := "Posting Date";
            GenJnlLine.Validate("Account No.", "Vendor No.");
            GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
            GenJnlLine.Validate("Bal. Account No.", GetBankAccount()."No.");
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
            if SummarizePerVendor() then
                GenJnlLine.Validate("Applies-to ID", "Document No.")
            else begin
                GenJnlLine.Validate("Applies-to Doc. Type", GenJnlLine."Applies-to Doc. Type"::Invoice);
                GenJnlLine.Validate("Applies-to Doc. No.", "Document No.");
            end;
            GenJnlLine."Payment Method Code" := GetPaymentMethod();
            if "External Document No." = '' then
                GenJnlLine."External Document No." := "Document No."
            else
                GenJnlLine."External Document No." := "External Document No.";
            GenJnlLine.Insert(true);
        end;

        if not SummarizePerVendor() then
            exit;

        if CheckData.Get("Document No.") then begin
            CheckData."Applies-to ID" := GenJnlLine."Applies-to ID";
            CheckData.Modify();
        end;

        VendorLedgerEntry.SetRange("Vendor No.", "Vendor No.");
        VendorLedgerEntry.SetRange("Document No.", "Document No.");
        VendorLedgerEntry.SetAutoCalcFields("Remaining Amount");
        if VendorLedgerEntry.FindFirst() then begin
            VendorLedgerEntry.Validate("Applies-to ID", GenJnlLine."Applies-to ID");
            VendorLedgerEntry.Validate("Amount to Apply", VendorLedgerEntry."Remaining Amount");
            VendorLedgerEntry.Modify(true);
        end;
    end;

    local procedure SummarizePerVendor(): Boolean
    var
        Vendor: Record Vendor;
    begin
        Vendor.Get("Vendor No.");
        // exit(Vendor."PTE Combine Payments" and "Group Claimant Vendor Checks");
        exit(Vendor."PTE Combine Payments");
    end;

    local procedure GetGenJournalLineForVendor(var GenJnlLine: Record "Gen. Journal Line"): boolean
    begin
        GenJnlLine.SetRange("Journal Template Name", GetPaymentJournalBatch()."Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", GetPaymentJournalBatch().Name);
        GenJnlLine.SetRange("Account No.", "Vendor No.");
        exit(GenJnlLine.FindLast());
    end;

    local procedure GetGenJnlLineNo(): Integer
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine.SetRange("Journal Template Name", GetPaymentJournalBatch()."Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", GetPaymentJournalBatch().Name);
        if GenJnlLine.FindLast() then
            exit(GenJnlLine."Line No." + 10000)
        else
            exit(10000);

    end;

    local procedure CreateVendorLedgerEntry()
    var
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
    begin
        GenJnlLine.Init();
        GenJnlLine."Document No." := "Document No.";
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Invoice;
        if "External Document No." = '' then
            GenJnlLine."External Document No." := "Document No."
        else
            GenJnlLine."External Document No." := "External Document No.";
        GenJnlLine."Posting Date" := "Posting Date";
        GenJnlLine.Description := Description;
        GenJnlLine.Amount := -"Amount (USD)";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;
        GenJnlLine."Account No." := "Vendor No.";
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
        GenJnlLine."Bal. Account No." := GetBalAccountFromVendor();
        GenJnlLine."Payment Method Code" := GetPaymentMethod();
        GenJnlPostLine.RunWithCheck(GenJnlLine);
    end;

    local procedure CreateCheckData(Base64String: Text)
    var
        CheckData: Record "PTE Check Data";
        Base64Convert: Codeunit "Base64 Convert";
        OutStr: OutStream;
    begin
        CheckData."Document Number" := "Document No.";
        if Base64String <> '' then begin
            CheckData.PDF.CreateOutStream(OutStr);
            Base64Convert.FromBase64(Base64String, OutStr);
            CheckData.Filename := "Document No." + '.pdf';
        end;

        CheckData.Client := Client;
        CheckData."TIN SSN" := "TIN SSN";
        CheckData."Claim Number" := "Claim Number";
        CheckData."Claimant Name" := "Claimant Name";
        CheckData."Loss Date" := "Loss Date";
        CheckData."Payment Type" := "Payment Type";
        CheckData."From Date" := "From Date";
        CheckData."Through Date" := "Through Date";
        CheckData."Invoice Date" := "Invoice Date";
        CheckData."Invoice No." := "Invoice No.";
        CheckData."Carrier Name 1" := "Carrier Name 1";
        CheckData."Carrier Name 2" := "Carrier Name 2";
        CheckData.Comment := Comment;
        CheckData."Department" := Department;
        CheckData."Adjuster Name" := "Adjuster Name";
        CheckData."Adjuster Phone" := "Adjuster Phone";
        CheckData."Event Number" := "Event Number";
        CheckData."Control Number" := "Control Number";
        CheckData."Additional Payee" := "Additional Payee";
        checkData."Additional Payee Text" := "Additional Payee Text";
        CheckData."Group Claimant Vendor Checks" := "Group Claimant Vendor Checks";
        CheckData."Claimant Id" := "Claimant Id";
        CheckData."Add. Pay. Name" := "Add. Pay. Name";
        CheckData."Add. Pay. Name 2" := "Add. Pay. Name 2";
        CheckData."Add. Pay. Address" := "Add. Pay. Address";
        CheckData."Add. Pay. Address 2" := "Add. Pay. Address 2";
        CheckData."Add. Pay. City" := "Add. Pay. City";
        CheckData."Add. Pay. Post Code" := "Add. Pay. Post Code";
        CheckData."Add. Pay. County" := "Add. Pay. County";
        CheckData."Add. Pay. Country/Region Code" := "Add. Pay. Country/Region Code";
        CheckData.Insert();
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
        if "Bank No." <> '' then begin
            BankAccount.Get("Bank No.");
            exit;
        end;

        BankAccount.SetRange("Bank Account No.", "Bank Account No.");
        BankAccount.FindFirst();
    end;

    local procedure GetPaymentJournalBatch() Batch: Record "Gen. Journal Batch"
    begin
        Batch.SetRange("Journal Template Name", 'PAYMENT');
        Batch.SetRange("Bal. Account Type", Batch."Bal. Account Type"::"Bank Account");
        Batch.SetRange("Bal. Account No.", GetBankAccount()."No.");
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