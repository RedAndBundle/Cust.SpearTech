table 80601 "PTEPI API PI Line"
{
    DataClassification = CustomerContent;
    Caption = 'API PI Header';
    TableType = Temporary;

    fields
    {
        field(1; "Policy Number"; Code[35])
        {
            DataClassification = CustomerContent;
            Caption = 'Policy Number';
        }
        field(2; "Spear No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Invoice Type';
        }
        field(3; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.';
        }
        // Line Details
        field(101; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';
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
        field(107; "Source"; Text[1024])
        {
            DataClassification = CustomerContent;
            Caption = 'Source';
        }
        field(108; "Source No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Source No.';
        }
        field(109; "Source Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(110; "Source Id"; Guid)
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Policy Number", "Spear No.", "Line No.")
        {
            Clustered = true;
        }
    }

    procedure ProcessAPInterface(): Text
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        CannotFindOrderErr: Label 'Cannot find a Sales Header for %1 %2, %3 %4', Comment = '%1 = fieldcaption %2=field %3= fieldcaption 2 %4 = field 2';
        CreatedLbl: Label '%1 %2 %3 Created', Comment = '%1 = doc type %2 = doc no %3= Line no';
    begin
        if not SalesHeader.PTEPIGetSalesHeader("Sales Document Type"::Invoice, "Policy Number", "Spear No.") then
            Error(CannotFindOrderErr, FieldCaption("Policy Number"), "Policy Number", FieldCaption("Spear No."), "Spear No.");

        CreateSalesLine(SalesHeader, SalesLine);
        exit(StrSubstNo(CreatedLbl, SalesLine."Document Type", SalesLine."Document No.", SalesLine."Line No."));
    end;

    local procedure CreateSalesLine(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    var
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
        SalesLine.Validate("No.", GetItem("Code"));
        SalesLine.Validate(Quantity, Units);
        SalesLine.Validate("Unit Price", Rate);
        SalesLine.Description := Description;
        SalesLine.Insert(true);
    end;

    local procedure GetItem(ItemNo: Code[20]): Code[20]
    var
        Item: Record Item;
    begin
        if not Item.Get(ItemNo) then
            CreateItem(Item, ItemNo);

        exit(Item."No.");
    end;

    local procedure CreateItem(var Item: Record Item; ItemNo: Code[20])
    var
        ItemTempl: Record "Item Templ.";
        Setup: Record "PTEPI Spear PI Setup";
        ItemTemplMgt: Codeunit "Item Templ. Mgt.";
    begin
        Setup.Get();
        ItemTempl.Get(Setup."Item Template");

        Item.Init();
        Item."No." := ItemNo;
        Item.Insert(true);

        ItemTemplMgt.ApplyItemTemplate(Item, ItemTempl, true);
    end;
}