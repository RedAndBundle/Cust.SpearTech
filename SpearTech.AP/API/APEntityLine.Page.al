Page 80504 "PTEAP API AP Line"
{
    DelayedInsert = true;
    DeleteAllowed = false;
    EntityName = 'apLine';
    EntitySetName = 'apLines';
    ODataKeyFields = SystemId;
    PageType = API;
    APIPublisher = 'speartech';
    APIGroup = 'ap';
    APIVersion = 'v2.0';
    SourceTable = "PTEAP API AP Line";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId) { ApplicationArea = Basic; }
                // Lines
                field(line_no; Rec."Line No.") { ApplicationArea = Basic; }
                field(task_activity; Rec."Task/Activity") { ApplicationArea = Basic; }
                field(task_code; Rec."Task Code") { ApplicationArea = Basic; }
                field(task_date; Rec."Task Date") { ApplicationArea = Basic; }
                field(units; Rec.Units) { ApplicationArea = Basic; }
                field(rate; Rec.Rate) { ApplicationArea = Basic; }
                field(amount; Rec.Amount) { ApplicationArea = Basic; }
                field(description; Rec.Description) { ApplicationArea = Basic; }
                field(result; Result) { ApplicationArea = Basic; }
            }
        }
    }

    var
        Result: Text;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        Setup: Record "PTEAP Spear AP Setup";
        Vendor: Record Vendor;
    begin
        // Rec.TestField("Sell-to Customer No.");
        // Rec.TestField("Claim Number");
        Rec.TestField("Task Code");
        Rec.TestField("Task/Activity");
        // Setup.Get();
        // Setup.TestField("Item Template");
        Result := Rec.ProcessAPInterface();
        // Error('bonk');
    end;
}
