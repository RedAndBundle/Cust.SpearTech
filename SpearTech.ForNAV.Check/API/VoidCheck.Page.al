Page 80403 "PTE Void Check"
{
    DelayedInsert = true;
    DeleteAllowed = false;
    EntityName = 'voidCheck';
    EntitySetName = 'voidChecks';
    ODataKeyFields = SystemId;
    PageType = API;
    APIPublisher = 'speartech';
    APIGroup = 'check';
    APIVersion = 'v2.0';
    SourceTable = "PTE Void Interface";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(vendorNo; Rec."Vendor No.") { ApplicationArea = Basic; }
                field(documentNo; Rec."Document No.") { ApplicationArea = Basic; }
                field(id; Rec.SystemId) { ApplicationArea = Basic; }
                field(result; Result) { ApplicationArea = Basic; }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.TestField("Vendor No.");
        Rec.TestField("Document No.");
        Result := Rec.VoidCheck();
    end;

    var
        Result: Text;
}
