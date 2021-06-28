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
        exit('Vendor Ledger Entries created and Payment Journal prepared');
    end;

    local procedure CreatePaymentJournalLine()
    var
        x: Report "Suggest Vendor Payments";
        Vendor: Record Vendor;
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine.Init;
        // LastLineNo := LastLineNo + 10000;
        // "Line No." := LastLineNo;
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
        // "Posting No. Series" := GenJnlBatch."Posting No. Series"; TODO Find batch based on Bank Account
        // if SummarizePerVend then
        //     "Document No." := TempPaymentBuffer."Document No."
        // else
        //     if DocNoPerLine then begin
        //         if TempPaymentBuffer.Amount < 0 then
        //             "Document Type" := "Document Type"::Refund;

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
        //             OldTempPaymentBuffer := TempPaymentBuffer;
        //             OldTempPaymentBuffer."Document No." := "Document No.";
        //         end;
        // "Account Type" := "Account Type"::Vendor;
        // SetHideValidation(true);
        // ShowPostingDateWarning := ShowPostingDateWarning or
        //   SetPostingDate(GenJnlLine, GetApplDueDate(TempPaymentBuffer."Vendor Ledg. Entry No."), PostingDate);
        // Validate("Account No.", TempPaymentBuffer."Vendor No.");
        // Vendor.Get(TempPaymentBuffer."Vendor No.");
        // if (Vendor."Pay-to Vendor No." <> '') and (Vendor."Pay-to Vendor No." <> "Account No.") then
        //     Message(Text025, Vendor.TableCaption, Vendor."No.", Vendor.FieldCaption("Pay-to Vendor No."),
        //       Vendor."Pay-to Vendor No.");
        // "Bal. Account Type" := BalAccType;
        // Validate("Bal. Account No.", BalAccNo);
        // Validate("Currency Code", TempPaymentBuffer."Currency Code");
        // "Message to Recipient" := GetMessageToRecipient(SummarizePerVend);
        // "Bank Payment Type" := BankPmtType;
        // if SummarizePerVend then
        //     "Applies-to ID" := "Document No.";
        // Description := Vendor.Name;
        // "Source Line No." := TempPaymentBuffer."Vendor Ledg. Entry No.";
        // "Shortcut Dimension 1 Code" := TempPaymentBuffer."Global Dimension 1 Code";
        // "Shortcut Dimension 2 Code" := TempPaymentBuffer."Global Dimension 2 Code";
        // "Dimension Set ID" := TempPaymentBuffer."Dimension Set ID";
        // "Source Code" := GenJnlTemplate."Source Code";
        // "Reason Code" := GenJnlBatch."Reason Code";
        // Validate(Amount, TempPaymentBuffer.Amount);
        // "Applies-to Doc. Type" := TempPaymentBuffer."Vendor Ledg. Entry Doc. Type";
        // "Applies-to Doc. No." := TempPaymentBuffer."Vendor Ledg. Entry Doc. No.";
        // "Payment Method Code" := TempPaymentBuffer."Payment Method Code";

        // TempPaymentBuffer.CopyFieldsToGenJournalLine(GenJnlLine);

        // OnBeforeUpdateGnlJnlLineDimensionsFromTempBuffer(GenJnlLine, TempPaymentBuffer, SummarizePerVend);
        // UpdateDimensions(GenJnlLine);
        // Insert;
        // GenJnlLineInserted := true;
        //  end;
        // end;
    end;

    local procedure CreateVendorLedgerEntry()
    var
        GenJnlLn: Record "Gen. Journal Line";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
    begin
        GenJnlLn.Init();
        GenJnlLn."Document No." := "Document No.";
        GenJnlLn."External Document No." := "External Document No.";
        GenJnlLn."Posting Date" := "Posting Date";
        GenJnlLn.Description := Description;
        GenJnlLn.Amount := "Amount (USD)";
        GenJnlLn."Account Type" := GenJnlLn."Account Type"::Vendor;
        GenJnlLn."Account No." := "Vendor No.";
        GenJnlLn."Bal. Account Type" := GenJnlLn."Bal. Account Type"::"G/L Account";
        GenJnlLn."Bal. Account No." := GetBalAccountFromVendor();
        GenJnlLn."Recipient Bank Account" := "Bank Account No.";
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
        OutStr.WriteText(Base64Convert.FromBase64(Base64String));
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
}