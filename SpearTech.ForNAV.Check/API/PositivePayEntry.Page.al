page 80406 "PTE Positive Pay Entry"
{
    DelayedInsert = true;
    DeleteAllowed = false;
    // InsertAllowed = false;
    ModifyAllowed = false;
    EntityName = 'positivePayEntry';
    EntitySetName = 'positivePayEntries';
    ODataKeyFields = SystemId;
    PageType = API;
    APIPublisher = 'speartech';
    APIGroup = 'check';
    APIVersion = 'v2.0';
    SourceTable = "Positive Pay Entry";
    // SourceTableTemporary = true;
    Extensible = false;

    // http://bc220-us:7048/bc/api/speartech/check/v2.0/companies(0616d885-5e36-ee11-bdfa-6045bdacc372)/positivePayEntries?$expand=positivePayEntryDetails&tenant=default
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(bankAccountNo; Rec."Bank Account No.") { ApplicationArea = All; }
                field(cutoffExportDate; CutoffExportDate) { ApplicationArea = All; }
                field(bankPaymentType; BankPaymentType) { ApplicationArea = All; }
                field(uploadDateTime; Rec."Upload Date-Time") { ApplicationArea = All; }
                field(lastUploadDate; Rec."Last Upload Date") { ApplicationArea = All; }
                field(lastUploadTime; Rec."Last Upload Time") { ApplicationArea = All; }
                field(accountNo; GetBankAccountNo()) { ApplicationArea = All; }
                field(numberOfUploads; Rec."Number of Uploads") { ApplicationArea = All; }
                field(numberOfChecks; Rec."Number of Checks") { ApplicationArea = All; }
                field(numberOfVoids; Rec."Number of Voids") { ApplicationArea = All; }
                field(checkAmount; Rec."Check Amount") { ApplicationArea = All; }
                field(voidAmount; Rec."Void Amount") { ApplicationArea = All; }
                field(confirmationNumber; Rec."Confirmation Number") { ApplicationArea = All; }
                field(systemId; Rec.SystemId) { ApplicationArea = All; }
            }
            part(details; "PTE Positive Pay Entry Details")
            {
                EntityName = 'positivePayEntryDetail';
                EntitySetName = 'positivePayEntryDetails';
                SubPageLink = SystemId = field("SystemId");
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.TestField("Bank Account No.");
        Rec.Insert();
        CreateExport();
        exit(false);
    end;

    var
        BankPaymentType: Enum "Bank Payment Type";
        CutoffExportDate: Date;

    local procedure CreateExport()
    var
        // PositivePayEntry: Record "Positive Pay Entry";
        CreatePositivePayEntry: Codeunit "PTE Create Positive Pay Entry";
    begin
        CreatePositivePayEntry.CreatePositivePayEntry(Rec, BankPaymentType, CutoffExportDate);
        // Rec.Get(Rec."Bank Account No.", Rec."Upload Date-Time");
        Rec.Modify();
        Rec.Find();
        Rec.SetRecFilter();
        // TODO Export Pos Pay Entries => Get details from pos pay subentries
    end;

    local procedure GetBankAccountNo(): Text
    var
        BankAccount: Record "Bank Account";
    begin
        BankAccount.Get(Rec."Bank Account No.");
        exit(BankAccount."Bank Account No.");
    end;
}