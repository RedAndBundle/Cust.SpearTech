Codeunit 50148 "PTE Test Check Report"
{
    Subtype = Test;
    [Test]
    [HandlerFunctions('SuggestVendorPaymentsRequestPageHandler,MessageHandler')]
    procedure TestSuggestVendorPayments()
    begin
        // [Given]
        Initialize;

        // [When]
        RunSuggestVendorPayments;
        CreatePDFForJournal;
        // [Then]
        TestJournalLinesExist;
    end;

    [Test]
    //    [HandlerFunctions('StrMenuHandler')]
    procedure TestCheck()
    var
        TempBlob: Record "ForNAV Core Setup";
        Args: Record "ForNAV Check Arguments";
        USCheck: Report "PTE Check Processing";
        FileMgt: Codeunit "File Management";
        Filename, Parameters : Text;
        OutStr: OutStream;
        InStr: InStream;
    begin
        // [Given]
        Initialize;

        // [When]
        TempBlob.Blob.CreateOutstream(OutStr);
        TempBlob.Blob.CreateInstream(InStr);

        Args."Bank Account No." := TestLib.FindValidBank;

        USCheck.SetArgs(Args);
        USCheck.InputBankAccount;
        USCheck.Run();
        // USCheck.SaveAs(Parameters, Reportformat::Pdf, OutStr);
        // CopyStream(OutStr, InStr);
        // Filename := 'result.pdf';
        // DownloadFromStream(InStr, '', '', '', Filename);

        // [Then]
        TestCheckprinted;
        TestCheckEntries;
    end;

    local procedure TestJournalLinesExist()
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.SetRange(GenJournalLine."Journal Template Name", TestLib.GetJournalTemplate);
        GenJournalLine.SetRange(GenJournalLine."Journal Batch Name", TestLib.GetJournalBatch);
        GenJournalLine.FindSet;
        repeat
            GenJournalLine.TestField(GenJournalLine."Check Printed", false);
            GenJournalLine.TestField(GenJournalLine."Bank Payment Type", GenJournalLine."Bank Payment Type"::"Computer Check".AsInteger());
        until GenJournalLine.Next = 0;

    end;

    local procedure RunSuggestVendorPayments()
    var
        GenJournalLine: Record "Gen. Journal Line";
        SuggestVendorPayments: Report "Suggest Vendor Payments";
        BalAccType: Option "G/L Account",Customer,Vendor,"Bank Account";
        BankPmtType: Option " ","Computer Check","Manual Check","Electronic Payment","Electronic Payment-IAT";
    begin
        GenJournalLine.SetRange(GenJournalLine."Journal Template Name", TestLib.GetJournalTemplate);
        GenJournalLine.SetRange(GenJournalLine."Journal Batch Name", TestLib.GetJournalBatch);
        GenJournalLine."Journal Template Name" := TestLib.GetJournalTemplate;
        GenJournalLine."Journal Batch Name" := TestLib.GetJournalBatch;


        SuggestVendorPayments.SetGenJnlLine(GenJournalLine);
        Commit;
        SuggestVendorPayments.Run;
    end;

    local procedure CreatePDFForJournal()
    var
        GenJnlLn: Record "Gen. Journal Line";
        PDFFile: Record "ForNAV File Storage";
    begin
        GenJnlLn.SetRange("Journal Template Name", TestLib.GetJournalTemplate);
        GenJnlLn.SetRange("Journal Batch Name", TestLib.GetJournalBatch);
        GenJnlLn.FindSet();
        repeat
            CreatePDF(GenJnlLn."Document No.", TestLib.GetSampleBase64PDF());
        until GenJnlLn.Next() = 0;
    end;

    local procedure Initialize()
    // var
    //     InitializeTest: Codeunit "ForNAV - Test Initialize Test";
    begin
        if IsInitialized then
            exit;

        // InitializeTest.TaxSetup;
        // InitializeTest.CheckSetup;
        Commit;

        IsInitialized := true;
    end;

    [RequestPageHandler]
    procedure SuggestVendorPaymentsRequestPageHandler(var SuggestVendorPayments: TestRequestPage "Suggest Vendor Payments")
    var
        BalAccType: Option "G/L Account",Customer,Vendor,"Bank Account";
        BankPmtType: Option " ","Computer Check","Manual Check","Electronic Payment","Electronic Payment-IAT";
        Test: Variant;
    begin
        SuggestVendorPayments.LastPaymentDate.SETVALUE(Today + 1000);
        SuggestVendorPayments.SkipExportedPayments.SETVALUE(true);
        SuggestVendorPayments.PostingDate.SETVALUE(Today + 1000);
        SuggestVendorPayments.StartingDocumentNo.SETVALUE('FORNAV01');
        SuggestVendorPayments.BalAccountType.SETVALUE(Balacctype::"Bank Account");
        SuggestVendorPayments.BalAccountNo.SETVALUE(TestLib.FindValidBank);
        SuggestVendorPayments.BankPaymentType.SETVALUE(Bankpmttype::"Computer Check");

        SuggestVendorPayments.OK.INVOKE;
    end;

    [MessageHandler]
    procedure MessageHandler(Value: Text[1024])
    begin
    end;

    procedure TestCheckEntries()
    var
        CheckLedgerEntry: Record "Check Ledger Entry";
    begin
        CheckLedgerEntry.FindSet;
    end;

    procedure TestCheckprinted()
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.SetRange(GenJournalLine."Journal Template Name", TestLib.GetJournalTemplate);
        GenJournalLine.SetRange(GenJournalLine."Journal Batch Name", TestLib.GetJournalBatch);
        GenJournalLine.FindSet;
        repeat
            GenJournalLine.TestField(GenJournalLine."Check Printed", true);
        until GenJournalLine.Next = 0;

    end;

    [StrMenuHandler]
    procedure StrMenuHandler(Options: Text[1024]; var Choice: Integer; Instruction: Text[1024])
    begin
        Choice := 1;
    end;

    local procedure CreatePDF(DocumentNo: Code[20]; Base64String: Text)
    var
        PDFFile: Record "ForNAV File Storage";
        Base64Convert: Codeunit "Base64 Convert";
        OutStr: OutStream;
    begin
        PDFFile.Code := DocumentNo;
        PDFFile.Data.CreateOutStream(OutStr);
        OutStr.WriteText(Base64Convert.FromBase64(Base64String));
        PDFFile.Insert();
    end;


    var
        TestLib: Codeunit "PTE Test Library";
        IsInitialized: Boolean;

}

