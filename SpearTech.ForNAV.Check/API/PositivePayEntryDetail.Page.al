page 80407 "PTE Positive Pay Entry Details"
{
    DelayedInsert = true;
    DeleteAllowed = false;
    // InsertAllowed = false;
    ModifyAllowed = false;
    EntityName = 'positivePayEntryDetail';
    EntitySetName = 'positivePayEntryDetails';
    ODataKeyFields = "Bank Account No.", "Upload Date-Time", "No.";
    PageType = API;
    APIPublisher = 'speartech';
    APIGroup = 'check';
    APIVersion = 'v2.0';
    SourceTable = "Positive Pay Entry Detail";
    // SourceTableTemporary = true;
    Extensible = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(bankAccountNo; Rec."Bank Account No.") { ApplicationArea = All; }
                field(uploadDateTime; Rec."Upload Date-Time") { ApplicationArea = All; }
                field(no; Rec."No.") { ApplicationArea = All; }
                field(checkNo; Rec."Check No.") { ApplicationArea = All; }
                field(currencyCode; Rec."Currency Code") { ApplicationArea = All; }
                field(documentType; Rec."Document Type") { ApplicationArea = All; }
                field(documentDate; Rec."Document Date") { ApplicationArea = All; }
                field(amount; Rec."Amount") { ApplicationArea = All; }
                field(payee; Rec.Payee) { ApplicationArea = All; }
                field(userID; Rec."User ID") { ApplicationArea = All; }
                field(updateDate; Rec."Update Date") { ApplicationArea = All; }
            }
        }
    }

    trigger OnFindRecord(Which: Text): Boolean
    var
        PositivePayEntry: Record "Positive Pay Entry";
    begin
        if rec.GetFilter(SystemId) <> '' then begin
            PositivePayEntry.SetFilter(SystemId, rec.GetFilter(SystemId));
            PositivePayEntry.FindFirst();
            Rec.Reset();
            Rec.SetRange("Bank Account No.", PositivePayEntry."Bank Account No.");
            Rec.SetRange("Upload Date-Time", PositivePayEntry."Upload Date-Time");
        end;

        exit(Rec.FindSet());
    end;
}