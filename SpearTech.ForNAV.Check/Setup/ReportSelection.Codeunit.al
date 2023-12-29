codeunit 80405 "PTE Report Selection"
{
    [EventSubscriber(ObjectType::Page, Page::"Report Selection - Bank Acc.", 'OnSetUsageFilterOnAfterSetFiltersByReportUsage', '', false, false)]
    local procedure OnSetUsageFilterOnAfterSetFiltersByReportUsage(var Rec: Record "Report Selections"; ReportUsage2: Enum "Report Selection Usage Bank")
    begin
        case ReportUsage2 of
            "Report Selection Usage Bank"::"PTE Spear Check":
                Rec.SetRange(Usage, "Report Selection Usage"::"PTE Spear Check");
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Report Selection - Bank Acc.", 'OnInitUsageFilterOnElseCase', '', false, false)]
    local procedure OnInitUsageFilterOnElseCase(ReportUsage: Enum "Report Selection Usage"; var ReportUsage2: Enum "Report Selection Usage Bank")
    begin
        case ReportUsage of
            "Report Selection Usage"::"PTE Spear Check":
                ReportUsage2 := "Report Selection Usage Bank"::"PTE Spear Check";
        end;
    end;
}