Report 50100 "PTE US Check"
{
    Caption = 'SpearTech Check';
    WordLayout = './Layouts/SpearTech US Check.docx';
    DefaultLayout = Word;

    dataset
    {
        dataitem(Args; "ForNAV Check Arguments")
        {
            DataItemTableView = sorting("Primary Key");
            UseTemporary = true;
            column(ReportForNavId_1000000002; 1000000002) { } // Autogenerated by ForNav - Do not delete
            column(ReportForNav_Args; ReportForNavWriteDataItem('Args', Args)) { }
            dataitem(VoidGenJnlLine; "Gen. Journal Line")
            {
                DataItemTableView = sorting("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
                RequestFilterFields = "Journal Template Name", "Journal Batch Name", "Posting Date";
                column(ReportForNavId_9788; 9788) { } // Autogenerated by ForNav - Do not delete
                column(ReportForNav_VoidGenJnlLine; ReportForNavWriteDataItem('VoidGenJnlLine', VoidGenJnlLine)) { }
                trigger OnPreDataItem();
                var
                    TestVoidCheck: Codeunit "ForNAV Test Void Check";
                begin
                    VoidGenJnlLine.SetRange("Bal. Account No.", Args."Bank Account No.");
                    if not TestVoidCheck.TestVoidCheck(VoidGenJnlLine, Args, CurrReport.Preview) then
                        CurrReport.Break;
                    ReportForNav.OnPreDataItem('VoidGenJnlLine', VoidGenJnlLine);
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
                DataItemTableView = sorting("Journal Template Name", "Journal Batch Name", "Line No.");
                UseTemporary = true;
                column(ReportForNavId_1000000001; 1000000001) { } // Autogenerated by ForNav - Do not delete
                column(ReportForNav_GenJnlLnBuffer; ReportForNavWriteDataItem('GenJnlLnBuffer', GenJnlLnBuffer)) { }
                dataitem(Model; "ForNAV Check Model")
                {
                    DataItemTableView = sorting("Page No.", "Part No.", "Line No.");
                    UseTemporary = true;
                    column(ReportForNavId_1000000004; 1000000004) { } // Autogenerated by ForNav - Do not delete
                    column(ReportForNav_Model; ReportForNavWriteDataItem('Model', Model)) { }
                    trigger OnPreDataItem();
                    begin
                        ReportForNav.OnPreDataItem('Model', Model);
                    end;
                }
                trigger OnPreDataItem();
                begin
                    CreateGenJnlLnBuffer;
                    ReportForNav.OnPreDataItem('GenJnlLnBuffer', GenJnlLnBuffer);
                end;

                trigger OnAfterGetRecord();
                begin
                    if not Args.CreateModelFromGenJnlLn(GenJnlLnBuffer, Model) then
                        CurrReport.Skip;
                    if Model.FindFirst() then
                        if Model."Amount Paid" < 0 then
                            Error(AmountCannotBeNegativeErr, GenJnlLnBuffer."Account Type", GenJnlLnBuffer."Account No.");
                end;

            }
            trigger OnPreDataItem();
            begin
                ReportForNav.OnPreDataItem('Args', Args);
            end;

            trigger OnAfterGetRecord();
            begin
            end;
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
                    field(BankAccount; Args."Bank Account No.")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Bank Account', Comment = 'DO NOT TRANSLATE';
                        TableRelation = "Bank Account";

                        trigger OnValidate()
                        begin
                            InputBankAccount;
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
                    field(ForNavOpenDesigner; ReportForNavOpenDesigner)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Design', Comment = 'DO NOT TRANSLATE';
                        Visible = ReportForNavAllowDesign;
                        trigger OnValidate()
                        begin
                            ReportForNav.LaunchDesigner(ReportForNavOpenDesigner);
                            CurrReport.RequestOptionsPage.Close();
                        end;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnClosePage()
        begin
            Args.Modify;
        end;

        trigger OnOpenPage()
        begin
            ReportForNavOpenDesigner := false;
            if not Args.Get then
                Args.Insert;
            InputBankAccount;
        end;
    }

    trigger OnInitReport()
    begin
        ;
        ReportsForNavInit;
        GetArgsFromSingleInstance();
    end;

    trigger OnPostReport()
    begin

    end;

    trigger OnPreReport()
    var
        PDFFile: Record "ForNAV File Storage";
        // GenJournalLine: Record "Gen. Journal Line";
        is: InStream;
    begin
        Codeunit.Run(Codeunit::"ForNAV First Time Setup");
        Commit;
        CheckSetupIsValid;
        LoadWatermark;
        Args.TestMandatoryFields;

        if CurrReport.Preview then
            Args."Test Print" := true;
        if PDFFile.Get(Args."PTE Document No.") then begin
            PDFFile.CalcFields(Data);
            PDFFile.Data.CreateInStream(is);
            ReportForNav.SetAppendPdf('Args', is);
        end;
        ReportsForNavPre;

    end;

    var
        AmountCannotBeNegativeErr: Label 'The total amount for %1 %2 cannot be negative', Comment = 'DO NOT TRANSLATE';

    local procedure GetArgsFromSingleInstance()
    var
        CheckArgs: Codeunit "PTE Check Args";
    begin
        Args := CheckArgs.GetArgs();
    end;

    procedure SetArgs(Value: Record "ForNAV Check Arguments")
    begin
        Args := Value;
    end;

    procedure InputBankAccount()
    var
        BankAccount: Record "Bank Account";
    begin
        if Args."Bank Account No." <> '' then begin
            BankAccount.Get(Args."Bank Account No.");
            BankAccount.TestField(Blocked, false);
            BankAccount.TestField("Last Check No.");
            Args."Check No." := BankAccount."Last Check No.";
        end;
    end;

    local procedure CheckSetupIsValid()
    var
        CheckSetup: Record "ForNAV Check Setup";
    begin
        CheckSetup.Get;
        if CheckSetup.Layout = CheckSetup.Layout::" " then
            CheckSetup.FieldError(CheckSetup.Layout);

    end;

    local procedure LoadWatermark()
    var
        CheckSetup: Record "ForNAV Check Setup";
        OutStream: OutStream;
    begin
        CheckSetup.Get;
        CheckSetup.CalcFields(CheckSetup.Watermark);
        if not CheckSetup.Watermark.Hasvalue then
            exit;

        ReportForNav.LoadWatermarkImage(CheckSetup.GetCheckWatermark);
    end;

    local procedure CreateGenJnlLnBuffer()
    var
        GenJnlLn: Record "Gen. Journal Line";
    begin
        if Args."Test Print" then begin
            GenJnlLnBuffer.Init;
            GenJnlLnBuffer.Insert;
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
            if GenJnlLn.FindSet then
                repeat
                    GenJnlLnBuffer := GenJnlLn;
                    GenJnlLnBuffer.Insert;
                until GenJnlLn.Next = 0;
        end;
    end;

    // --> Reports ForNAV Autogenerated code - do not delete or modify
    var
        ReportForNavInitialized: Boolean;
        ReportForNavShowOutput: Boolean;
        ReportForNavTotalsCausedBy: Boolean;
        ReportForNavOpenDesigner: Boolean;
        [InDataSet]
        ReportForNavAllowDesign: Boolean;
        ReportForNav: Codeunit "ForNAV Report Management";

    local procedure ReportsForNavInit()
    var
        id: Integer;
    begin
        Evaluate(id, CopyStr(CurrReport.ObjectId(false), StrPos(CurrReport.ObjectId(false), ' ') + 1));
        ReportForNav.OnInit(id, ReportForNavAllowDesign);
    end;

    local procedure ReportsForNavPre()
    begin
        if ReportForNav.LaunchDesigner(ReportForNavOpenDesigner) then CurrReport.Quit();
    end;

    local procedure ReportForNavSetTotalsCausedBy(value: Boolean)
    begin
        ReportForNavTotalsCausedBy := value;
    end;

    local procedure ReportForNavSetShowOutput(value: Boolean)
    begin
        ReportForNavShowOutput := value;
    end;

    local procedure ReportForNavInit(jsonObject: JsonObject)
    begin
        ReportForNav.Init(jsonObject, CurrReport.ObjectId);
    end;

    local procedure ReportForNavWriteDataItem(dataItemId: Text; rec: Variant): Text
    var
        values: Text;
        jsonObject: JsonObject;
        currLanguage: Integer;
    begin
        if not ReportForNavInitialized then begin
            ReportForNavInit(jsonObject);
            ReportForNavInitialized := true;
        end;

        case (dataItemId) of
        end;
        ReportForNav.AddDataItemValues(jsonObject, dataItemId, rec);
        jsonObject.WriteTo(values);
        exit(values);
    end;
    // Reports ForNAV Autogenerated code - do not delete or modify -->
}
