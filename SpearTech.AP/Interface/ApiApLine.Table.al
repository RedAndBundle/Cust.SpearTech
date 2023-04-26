table 80503 "PTEAP API AP Line"
{
    DataClassification = CustomerContent;
    Caption = 'API AP Header';
    TableType = Temporary;

    fields
    {
        field(1; "Claim Number"; Code[35])
        {
            DataClassification = CustomerContent;
            Caption = 'Claim Number';
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.';
        }
        // Line Details
        field(100; "Task/Activity"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Task/Activity';
        }
        field(101; "Task Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Task Code';
        }
        field(102; "Task Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Task Date';
        }
        field(103; "Units"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Units';
        }
        field(104; "Rate"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Rate';
        }
        field(105; "Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount';
        }
        field(106; "Description"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Claim Number", "Line No.")
        {
            Clustered = true;
        }
    }

    procedure ProcessAPInterface(): Text
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        CannotFindOrderErr: Label 'Cannot find a Sales Header for %1 %2', Comment = '%1 = fieldcaption %2=field';
    begin
        // if FindSet() then
        //     repeat
        if not SalesHeader.PTEGetSalesHeader("Sales Document Type"::Invoice, "Claim Number") then
            Error(CannotFindOrderErr, FieldCaption("Claim Number"), "Claim Number");

        CreateSalesLine(SalesHeader);
        // until Next() = 0;
        exit(StrSubstNo('%1 %2 Created', SalesHeader."Document Type", SalesHeader."No."));
    end;

    local procedure CreateSalesLine(SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        LastLineNo: Integer;
    begin
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.LockTable();
        if SalesLine.FindLast() then
            LastLineNo := SalesLine."Line No.";

        SalesLine.Init();
        SalesLine."Document Type" := SalesHeader."Document Type";
        SalesLine."Document No." := SalesHeader."No.";
        SalesLine."Line No." := LastLineNo + 10000;
        SalesLine.Validate(Type, SalesLine.Type::Item);
        SalesLine.Validate("No.", GetItem("Task Code"));
        SalesLine.Validate(Quantity, Units);
        SalesLine.Validate("Unit Price", Rate);
        SalesLine.Description := Description;
        SalesLine."PTEAP Task/Activity" := "Task/Activity";
        SalesLine."PTEAP Task Date" := "Task Date";
        SalesLine.Insert(true);
    end;

    local procedure GetItem(ItemNo: Code[20]): Code[20]
    var
        Item: Record Item;
        Setup: Record "PTEAP Spear AP Setup";
        ItemTemplMgt: Codeunit "Item Templ. Mgt.";
        IsHandled: Boolean;
        CannotCreateItemFromTemplateErr: Label 'Cannot create a new item from template %1', Comment = '%1 is termplate code';
    begin
        Does not create the item with the original item no.Needs to do that;
        Instead of calling the whole auto shebang init item + no manually then call:;
        ItemTemplMgt.ApplyItemTemplate(Item, ItemTemplate);
        Setup.Get();
        if not Item.Get(ItemNo) then begin
            if not ItemTemplMgt.CreateItemFromTemplate(Item, IsHandled, Setup."Item Template") then
                error(CannotCreateItemFromTemplateErr, Setup."Item Template");
        end;
        exit(Item."No.");
    end;
}