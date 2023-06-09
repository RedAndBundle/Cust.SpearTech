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
}
