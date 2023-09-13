Page 80401 "PTE Check Nos."
{
    DelayedInsert = true;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    EntityName = 'checkNo';
    EntitySetName = 'checkNos';
    ODataKeyFields = SystemId;
    PageType = API;
    APIPublisher = 'speartech';
    APIGroup = 'check';
    APIVersion = 'v2.0';
    SourceTable = "Bank Account Ledger Entry";
    SourceTableView = where("Document Type" = const(Payment));
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(checkNo; Rec."Document No.") { ApplicationArea = Basic, Suite; }
                field(id; Rec.SystemId) { ApplicationArea = Basic, Suite; }
                field(createdAt; Rec.SystemCreatedAt) { ApplicationArea = Basic, Suite; }
                field(documentNo; Rec."Document No.") { ApplicationArea = Basic, Suite; }
                field(externalDocumentNo; Rec."External Document No.") { ApplicationArea = Basic, Suite; }
                field(amount; -Rec.Amount) { ApplicationArea = Basic, Suite; }
            }
        }
    }

    // http://bc220-us:7048/bc/api/speartech/check/v2.0/companies(0616d885-5e36-ee11-bdfa-6045bdacc372)/checkNos?$filter=externalDocumentNo eq 'checktestAtt04'&tenant=default
    // http://bc220-us:7048/bc/api/speartech/check/v2.0/companies(0616d885-5e36-ee11-bdfa-6045bdacc372)/checkNos?$filter=startswith(externalDocumentNo, 'checktestAtt')&tenant=default
    trigger OnFindRecord(Which: Text): Boolean
    begin
        Rec.DeleteAll();
        Message(Which);
        if Rec.GetFilter("External Document No.") = '' then
            exit(GetFromBankAccountLedgerEntry());

        exit(GetFromVendorLedgerEntry(Which));
    end;

    local procedure GetFromBankAccountLedgerEntry(): Boolean
    var
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
    begin
        BankAccountLedgerEntry.CopyFilters(Rec);
        if not BankAccountLedgerEntry.FindFirst() then
            exit(false);

        Rec := BankAccountLedgerEntry;
        Rec.Insert();
        exit(true);
    end;

    local procedure GetFromVendorLedgerEntry(Which: Text): Boolean
    var
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        VendorLedgerEntry2: Record "Vendor Ledger Entry";
    begin
        VendorLedgerEntry.SetFilter("External Document No.", Rec.GetFilter("External Document No."));
        VendorLedgerEntry.SetRange("Document Type", VendorLedgerEntry."Document Type"::Invoice);
        if not VendorLedgerEntry.Find(Which) then
            exit(false);

        repeat
            VendorLedgerEntry2.SetRange("Document Type", VendorLedgerEntry2."Document Type"::Payment);
            if vendorLedgerEntry."Applies-to ID" = '' then
                VendorLedgerEntry2.SetRange("External Document No.", VendorLedgerEntry."External Document No.")
            else
                VendorLedgerEntry2.SetRange("External Document No.", VendorLedgerEntry."Applies-to ID");

            If VendorLedgerEntry2.FindFirst() then begin
                BankAccountLedgerEntry.SetRange("Document Type", BankAccountLedgerEntry."Document Type"::Payment);
                BankAccountLedgerEntry.SetRange("Bank Account No.", VendorLedgerEntry2."Bal. Account No.");
                BankAccountLedgerEntry.SetRange("Document No.", VendorLedgerEntry2."Document No.");
                BankAccountLedgerEntry.FindFirst();

                Rec := BankAccountLedgerEntry;
                Rec."Entry No." := VendorLedgerEntry2."Entry No.";
                Rec."External Document No." := VendorLedgerEntry."External Document No.";
                // Rec."Document Date" := VendorLedgerEntry2."Posting Date";
                // Rec."Document No." := VendorLedgerEntry2."Document No.";
                // Rec.Amount := VendorLedgerEntry2.Amount;
                // Rec.SystemId := VendorLedgerEntry2.SystemId;
                Rec.Insert();
            end;
        until VendorLedgerEntry.Next() = 0;
        Rec.Reset();
        Rec.FindSet();
        exit(Rec.FindSet());
    end;
}
