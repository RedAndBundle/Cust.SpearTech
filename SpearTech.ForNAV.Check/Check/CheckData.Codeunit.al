codeunit 80403 "PTE Check Data"
{
    Permissions = tabledata "PTE Check Data" = RIMD;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterDeleteEvent', '', false, false)]
    local procedure OnAfterDeleteEvent(RunTrigger: Boolean; var Rec: Record "Gen. Journal Line")
    begin
        DeleteCheckData(Rec);
    end;

    local procedure DeleteCheckData(var GenJnlLine: Record "Gen. Journal Line")
    var
        CheckData: Record "PTE Check Data";
    begin
        case false of
            GenJnlLine."Document Type" = GenJnlLine."Document Type"::Payment,
            GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor,
            GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::"Bank Account":
                exit;
        end;

        if CheckData.Get(GenJnlLine."Applies-to Doc. No.") then
            CheckData.Delete();
    end;
}