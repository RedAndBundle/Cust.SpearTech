Report 80401 "PTE Check Processing"
{
    Caption = 'SpearTech Check Batch';
    ProcessingOnly = true;
    dataset
    {
        dataitem(Args; "ForNAV Check Arguments")
        {
            DataItemTableView = sorting("Primary Key");
            UseTemporary = true;
            dataitem(VoidGenJnlLine; "Gen. Journal Line")
            {
                DataItemTableView = sorting("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
                trigger OnPreDataItem();
                var
                    TestVoidCheck: Codeunit "ForNAV Test Void Check";
                begin
                    VoidGenJnlLine.SetFilter("Bal. Account No.", '%1|%2', '', Args."Bank Account No.");
                    if not TestVoidCheck.TestVoidCheck(VoidGenJnlLine, Args, CurrReport.Preview) then
                        CurrReport.Break();
                end;

                trigger OnAfterGetRecord();
                var
                    CheckManagement: Codeunit CheckManagement;
                begin
                    CheckManagement.VoidCheck(VoidGenJnlLine);
                end;

            }
            dataitem(GenJnlLnBuffer; "Gen. Journal Line")
            {
                UseTemporary = true;
                DataItemTableView = sorting("Journal Template Name", "Journal Batch Name", "Line No.");
                trigger OnPreDataItem();
                begin
                    GenJnlLnBuffer.Reset();
                    Args."Reprint Checks" := false;
                    CreateGenJnlLnBuffer();
                end;

                trigger OnAfterGetRecord();
                var
                    RunCheck: Codeunit "PTE Run Check Report";
                begin
                    RunCheck.RunCheckReportPerLine(Args, GenJnlLnBuffer);
                end;

            }
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(BankAccountFld; Args."Bank Account No.")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Bank Account', Comment = 'DO NOT TRANSLATE';
                        TableRelation = "Bank Account";

                        trigger OnValidate()
                        begin
                            InputBankAccount();
                        end;
                    }
                    field(LastCheckNo; Args."Check No.")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Last Check No.', Comment = 'DO NOT TRANSLATE';
                    }
                    field(OneCheckPerVendorPerDocumentNo; Args."One Check Per Vendor")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'One Check per Vendor per Document No.', Comment = 'DO NOT TRANSLATE';
                        MultiLine = true;

                        trigger OnValidate()
                        begin
                            Args.TestField("Test Print", false);
                        end;
                    }
                    field(ReprintChecks; Args."Reprint Checks")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Reprint Checks', Comment = 'DO NOT TRANSLATE';
                    }
                    field(TestPrinting; Args."Test Print")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Test Print', Comment = 'DO NOT TRANSLATE';

                        trigger OnValidate()
                        begin
                            Args."One Check Per Vendor" := false;
                        end;
                    }
                    field(OutputType; Args."PTE Output Type")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Output Type', Comment = 'DO NOT TRANSLATE';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnClosePage()
        begin
            Args.Modify();
        end;

        trigger OnOpenPage()
        var
            Setup: Record "PTE Spear Technology Setup";
        begin
            Setup.Get();
            if not Args.Get() then
                Args.Insert();
            GetBankAccFromFirstGnlLine();
            InputBankAccount();
        end;
    }

    trigger OnPreReport()
    begin
        Codeunit.Run(Codeunit::"ForNAV First Time Setup");
        Commit();
        CheckSetupIsValid();
        Args.TestMandatoryFields();
        if CurrReport.Preview then
            Args."Test Print" := true;

    end;

    procedure SetArgs(Value: Record "ForNAV Check Arguments")
    begin
        Args := Value;
    end;

    local procedure GetBankAccFromFirstGnlLine()
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.CopyFilters(VoidGenJnlLine);
        GenJournalLine.SetRange("Bal. Account Type", GenJournalLine."Bal. Account Type"::"Bank Account");
        GenJournalLine.SetFilter("Bal. Account No.", '<>%1', '');
        if GenJournalLine.FindFirst() then
            Args."Bank Account No." := GenJournalLine."Bal. Account No.";
    end;

    procedure InputBankAccount()
    // var
    //     BankAccount: Record "Bank Account";
    begin
        Args.PTEGetLastCheckNo();
        // if Args."Bank Account No." <> '' then begin
        //     BankAccount.Get(Args."Bank Account No.");
        //     BankAccount.TestField(Blocked, false);
        //     BankAccount.TestField("Last Check No.");
        //     Args."Check No." := BankAccount."Last Check No.";
        // end;
    end;

    local procedure CheckSetupIsValid()
    var
        CheckSetup: Record "ForNAV Check Setup";
    begin
        CheckSetup.Get();
        if CheckSetup.Layout = CheckSetup.Layout::" " then
            CheckSetup.FieldError(CheckSetup.Layout);
    end;

    local procedure CreateGenJnlLnBuffer()
    var
        GenJnlLn: Record "Gen. Journal Line";
    begin
        if Args."Test Print" then begin
            GenJnlLnBuffer.Init();
            GenJnlLnBuffer.Insert();
        end else begin
            GenJnlLn.Copy(VoidGenJnlLine);
            if not Args."Test Print" then begin
                GenJnlLn.SetRange(GenJnlLn."Bank Payment Type", GenJnlLn."bank payment type"::"Computer Check");
                GenJnlLn.SetRange(GenJnlLn."Check Printed", false);
                GenJnlLn.SetRange("Bal. Account No.", Args."Bank Account No.");
            end;
            GenJnlLn.SetRange(GenJnlLn."Account Type", GenJnlLn."account type"::"Fixed Asset");
            if GenJnlLn.Find('-') then
                GenJnlLn.FieldError(GenJnlLn."Account Type");
            GenJnlLn.SetRange(GenJnlLn."Account Type");
            if GenJnlLn.FindSet() then
                repeat
                    GenJnlLnBuffer := GenJnlLn;
                    GenJnlLnBuffer.Insert();
                until GenJnlLn.Next() = 0;
        end;
    end;
}
