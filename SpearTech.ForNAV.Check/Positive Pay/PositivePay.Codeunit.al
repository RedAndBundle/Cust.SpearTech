codeunit 80400 "PTE Create Positive Pay Entry"
{
    Permissions = TableData "Check Ledger Entry" = rimd,
                  TableData "Positive Pay Entry" = rimd,
                  TableData "Positive Pay Entry Detail" = rimd;

    internal procedure CreatePositivePayEntry(var PositivePayEntry: Record "Positive Pay Entry"; BankPaymentType: Enum "Bank Payment Type")
    var
        CheckLedgerEntry: Record "Check Ledger Entry";
        PositivePayEntryDetail: Record "Positive Pay Entry Detail";
    begin
        if not GetCheckLedgerEntries(PositivePayEntry, CheckLedgerEntry, BankPaymentType) then
            exit;

        InitPositivePayEntry(PositivePayEntry, CheckLedgerEntry."Bank Account No.");

        repeat
            CreatePosPayEntryDetail(CheckLedgerEntry, PositivePayEntryDetail, PositivePayEntry);
        until CheckLedgerEntry.Next() = 0;

        SetPositivePayEntryTotals(PositivePayEntry);
        SetPositivePayExported(CheckLedgerEntry);
    end;

    local procedure GetCheckLedgerEntries(var PositivePayEntry: Record "Positive Pay Entry"; var CheckLedgerEntry: Record "Check Ledger Entry"; BankPaymentType: Enum "Bank Payment Type"): Boolean
    begin
        CheckLedgerEntry.SetCurrentKey("Bank Account No.", "Check Date");
        CheckLedgerEntry.SetRange("Bank Account No.", PositivePayEntry."Bank Account No.");
        CheckLedgerEntry.SetRange("Check Date", PositivePayEntry."Last Upload Date", WorkDate());
        CheckLedgerEntry.SetRange("Positive Pay Exported", false);
        if BankPaymentType <> Enum::"Bank Payment Type"::" " then
            CheckLedgerEntry.SetRange("Bank Payment Type", BankPaymentType);

        exit(CheckLedgerEntry.FindSet());
    end;

    local procedure InitPositivePayEntry(var PositivePayEntry: Record "Positive Pay Entry"; BankAccountNo: Code[20])
    begin
        PositivePayEntry.Init();
        PositivePayEntry.Validate("Bank Account No.", BankAccountNo);
        PositivePayEntry."Upload Date-Time" := CurrentDateTime();
        PositivePayEntry."Last Upload Date" := DT2Date(GetLastUploadDateTime(PositivePayEntry."Bank Account No."));
        PositivePayEntry."Last Upload Time" := DT2Time(GetLastUploadDateTime(PositivePayEntry."Bank Account No."));
        PositivePayEntry.Insert();
    end;

    local procedure CreatePosPayEntryDetail(var CheckLedgerEntry: Record "Check Ledger Entry"; var PositivePayEntryDetail: Record "Positive Pay Entry Detail"; PositivePayEntry: Record "Positive Pay Entry")
    var
        BankAccount: Record "Bank Account";
    begin
        BankAccount.Get(CheckLedgerEntry."Bank Account No.");

        PositivePayEntryDetail.Init();
        PositivePayEntryDetail."Upload Date-Time" := PositivePayEntry."Upload Date-Time";
        PositivePayEntryDetail."Bank Account No." := PositivePayEntry."Bank Account No.";
        PositivePayEntryDetail."No." := PositivePayEntryDetail."No." + 1;
        PositivePayEntryDetail."Check No." := CheckLedgerEntry."Check No.";
        PositivePayEntryDetail."Currency Code" := BankAccount."Currency Code";

        case CheckLedgerEntry."Entry Status" of
            CheckLedgerEntry."Entry Status"::Printed,
            CheckLedgerEntry."Entry Status"::Posted:
                PositivePayEntryDetail."Document Type" := PositivePayEntryDetail."Document Type"::CHECK;
            CheckLedgerEntry."Entry Status"::Voided,
          CheckLedgerEntry."Entry Status"::"Financially Voided",
            CheckLedgerEntry."Entry Status"::"Test Print":
                PositivePayEntryDetail."Document Type" := PositivePayEntryDetail."Document Type"::VOID;
        end;

        PositivePayEntryDetail."Document Date" := CheckLedgerEntry."Check Date";
        PositivePayEntryDetail.Amount := CheckLedgerEntry.Amount;
        PositivePayEntryDetail.Payee := CheckLedgerEntry.Description;
        PositivePayEntryDetail."User ID" := UserId;
        PositivePayEntryDetail."Update Date" := Today;
        PositivePayEntryDetail.Insert();
    end;

    local procedure SetPositivePayEntryTotals(var PositivePayEntry: Record "Positive Pay Entry")
    var
        PositivePayEntryDetail: Record "Positive Pay Entry Detail";
    begin
        PositivePayEntryDetail.SetRange("Upload Date-Time", PositivePayEntry."Upload Date-Time");
        PositivePayEntryDetail.SetRange("Bank Account No.", PositivePayEntry."Bank Account No.");
        if PositivePayEntryDetail.FindSet() then
            repeat
                if PositivePayEntryDetail."Document Type" = PositivePayEntryDetail."Document Type"::CHECK then begin
                    PositivePayEntry."Number of Checks" += 1;
                    PositivePayEntry."Check Amount" += PositivePayEntryDetail.Amount;
                end else begin
                    PositivePayEntry."Number of Voids" += 1;
                    PositivePayEntry."Void Amount" += PositivePayEntryDetail.Amount;
                end;
            until PositivePayEntryDetail.Next() = 0;

        PositivePayEntry."Number of Uploads" += 1;
        PositivePayEntry.Modify();
    end;

    local procedure SetPositivePayExported(var CheckLedgerEntry: Record "Check Ledger Entry")
    begin
        CheckLedgerEntry.ModifyAll("Positive Pay Exported", true, true);
    end;

    local procedure GetLastUploadDateTime(BankAccNo: Code[20]): DateTime
    var
        PositivePayEntry: Record "Positive Pay Entry";
    begin
        PositivePayEntry.SetRange("Bank Account No.", BankAccNo);
        if PositivePayEntry.FindLast() then
            exit(PositivePayEntry."Upload Date-Time");
    end;
}