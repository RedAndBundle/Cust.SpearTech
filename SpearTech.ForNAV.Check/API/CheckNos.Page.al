Page 50101 "PTE Check Nos."
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
    SourceTable = "Check Ledger Entry";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(checkNo; Rec."Check No.") { ApplicationArea = Basic; }
                field(id; Rec.SystemId) { ApplicationArea = Basic; }
                field(createdAt; Rec.SystemCreatedAt) { ApplicationArea = Basic; }
                field(documentNo; Rec."Document No.") { ApplicationArea = Basic; }
                field(externalDocumentNo; Rec."External Document No.") { ApplicationArea = Basic; }
            }
        }
    }
}
