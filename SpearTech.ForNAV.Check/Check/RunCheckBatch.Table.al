table 80404 "PTE Run Check Batch"
{
    Caption = 'Run Check Batch';
    DataCaptionFields = Name, Description;
    TableType = Temporary;

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            NotBlank = true;
            TableRelation = "Gen. Journal Template";
        }
        field(2; Name; Code[10])
        {
            Caption = 'Name';
            NotBlank = true;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(5; "Bal. Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Bal. Account Type';
        }
        field(6; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
        }

        field(80400; "Run Check"; Boolean)
        {
            Caption = 'Run Check';

            trigger OnValidate()
            begin
                if ("Bank Account No." = '') or ("Last Check No." = '') then
                    Error('You cannot run a check without a bank account or last check no.');
            end;
        }
        field(80401; "Bank Account No."; Code[20])
        {
            Caption = 'Bank Account No.';
            TableRelation = "Bank Account";

            trigger OnValidate()
            begin
                "Last Check No." := InputBankAccount("Bank Account No.");
                "Run Check" := "Last Check No." <> '';
            end;
        }
        field(80402; "Last Check No."; Code[20])
        {
            Caption = 'Last Check No.';

            trigger OnValidate()
            begin
                if "Bank Account No." = '' then
                    "Last Check No." := '';

                "Run Check" := "Last Check No." <> '';
            end;
        }
        field(80403; "Reprint Checks"; boolean)
        {
            Caption = 'Reprint Checks';
        }
        field(80404; "One Check Per Vendor"; Boolean)
        {
            Caption = 'One Check Per Vendor';
        }
    }

    keys
    {
        key(Key1; "Journal Template Name", Name)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(Brick; Name, "Journal Template Name", Description, "Bal. Account Type", "Bal. Account No.")
        {
        }
    }

    internal procedure GetBatches()
    var
        GenJournalBatch: Record "Gen. Journal Batch";
    begin
        DeleteAll();
        GenJournalBatch.SetRange("Journal Template Name", 'PAYMENT');
        if GenJournalBatch.FindSet() then
            repeat
                "Journal Template Name" := GenJournalBatch."Journal Template Name";
                Name := GenJournalBatch.Name;
                Description := GenJournalBatch.Description;
                "Bal. Account Type" := GenJournalBatch."Bal. Account Type";
                "Bal. Account No." := GenJournalBatch."Bal. Account No.";
                "Bank Account No." := GetBankAccFromFirstGnlLine(GenJournalBatch);
                "Last Check No." := InputBankAccount("Bank Account No.");
                "Run Check" := "Last Check No." <> '';
                Insert();
            until GenJournalBatch.Next() = 0;
    end;

    local procedure GetBankAccFromFirstGnlLine(GenJournalBatch: Record "Gen. Journal Batch"): Code[20]
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.SetRange("Journal Template Name", GenJournalBatch."Journal Template Name");
        GenJournalLine.SetRange("Journal Batch Name", GenJournalBatch.Name);
        GenJournalLine.SetRange("Bal. Account Type", GenJournalLine."Bal. Account Type"::"Bank Account");
        GenJournalLine.SetFilter("Bal. Account No.", '<>%1', '');
        if GenJournalLine.FindFirst() then
            exit(GenJournalLine."Bal. Account No.");
    end;

    procedure InputBankAccount(BankAccountNo: Code[20]): Code[20]
    var
        BankAccount: Record "Bank Account";
    begin
        if BankAccountNo = '' then
            exit;

        BankAccount.Get(BankAccountNo);
        BankAccount.TestField(Blocked, false);
        BankAccount.TestField("Last Check No.");
        exit(BankAccount."Last Check No.");
    end;

    internal procedure PrintChecks()
    var
        Args: Record "ForNAV Check Arguments" temporary;
        GenJournalBatch: Record "Gen. Journal Batch";
        Setup: Record "PTE Spear Technology Setup";
        TempMergePDF: Record "PTE PDF Merge File" temporary;
        RunCheckReport: Codeunit "PTE Run Check Report";
    begin
        Setup.Get();
        Setup.TestPDFSetup();

        if Rec.FindSet() then
            repeat
                if "Run Check" then begin
                    Args.DeleteAll();
                    Args.Init();
                    Args."Bank Account No." := "Bank Account No.";
                    Args."Reprint Checks" := "Reprint Checks";
                    Args."One Check Per Vendor" := "One Check Per Vendor";
                    Args."Check No." := InputBankAccount("Bank Account No.");
                    Args."PTE Document No." := '';
                    Args."PTE Output Type" := Args."PTE Output Type"::PDF;
                    Args.Insert();
                    GenJournalBatch.Get("Journal Template Name", Name);
                    RunCheckReport.RunCheckReportPerBatch(Args, GenJournalBatch, TempMergePDF);
                    Modify();
                end;
            until Rec.Next() = 0;

        case Setup."Output Type" of
            Setup."Output Type"::Zip:
                TempMergePDF.Zip();
            Setup."Output Type"::PDF:
                TempMergePDF.MergeAndPreview();
        end;
    end;
}

