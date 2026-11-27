"! <p class="shorttext synchronized" lang="en">abap2UI5 customer frontend extension - example</p>
"!
"! Start with: <em>?app_start=z2ui5_cl_ccc_sample_01</em>
"!
"! How an app uses what this branch ships (a real customer example):
"! <ul>
"! <li>the icon font - <em>sap-icon://my-icons/&lt;name&gt;</em> on any icon
"! property, the names are the ones in ICONS of cc/Extension.js</li>
"! <li>the row colours - a CustomData <em>color</em> with writeToDom on the
"! row puts data-color="&lt;key&gt;" on the tr, css/style.css colours it</li>
"! <li>the column-sort header - a Link with the class customerColSort looks
"! like a plain column header</li>
"! <li>the scope - the view carries the class customerApp, so the rules that
"! must not hit other apps on the page apply to this view only</li>
"! </ul>
"! z2ui5_cl_ccc=>render( ) loads all of it, once per page.
CLASS z2ui5_cl_ccc_sample_01 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_row,
        hu       TYPE string,
        product  TYPE string,
        quantity TYPE i,
        color    TYPE string,
      END OF ty_s_row.
    TYPES ty_t_row TYPE STANDARD TABLE OF ty_s_row WITH DEFAULT KEY.

    " ONLY bound data here - PUBLIC attributes are serialized every roundtrip
    DATA t_row       TYPE ty_t_row.
    DATA descending  TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS sort_rows.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ccc_sample_01 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.
      DATA temp1 TYPE z2ui5_cl_ccc_sample_01=>ty_t_row.
      DATA temp2 LIKE LINE OF temp1.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.

      CLEAR temp1.

      temp2-hu = `1000001`.
      temp2-product = `Pallet A`.
      temp2-quantity = 40.
      temp2-color = `grey_2`.
      INSERT temp2 INTO TABLE temp1.
      temp2-hu = `1000002`.
      temp2-product = `Pallet B`.
      temp2-quantity = 12.
      temp2-color = `red_2`.
      INSERT temp2 INTO TABLE temp1.
      temp2-hu = `1000003`.
      temp2-product = `Box C`.
      temp2-quantity = 3.
      temp2-color = ``.
      INSERT temp2 INTO TABLE temp1.
      temp2-hu = `1000004`.
      temp2-product = `Box D`.
      temp2-quantity = 7.
      temp2-color = `grey_4`.
      INSERT temp2 INTO TABLE temp1.
      t_row = temp1.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.

  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA root TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA icons TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    DATA temp3 LIKE temp1.
    DATA icon LIKE LINE OF temp3.
      DATA temp4 TYPE string_table.
    DATA table TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA columns TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA item TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA cells TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " customerApp scopes the rules of css/style.css that must not reach the
    " other apps on the page

    root = view->ele( n  = `View`
                            ns = `mvc`
        )->a( n = `xmlns`
              v = `sap.m`
        )->a( n = `xmlns:mvc`
              v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core`
              v = `sap.ui.core`
        )->a( n = `displayBlock`
              v = `true`
        )->a( n = `height`
              v = `100%`
        )->a( n = `class`
              v = `customerApp` ).

    z2ui5_cl_ccc=>xmlns( root ).


    page = root->ele( `Page`
        )->a( n = `title`
              v = `Customer example - icons, row colours, column sort` ).

    " loads the icon font, the icon names and the stylesheet - before the
    " controls that use them
    z2ui5_cl_ccc=>render( page ).

    " 1. the icon font: sap-icon://my-icons/<name>

    icons = page->ele( `HBox`
        )->a( n = `class`
              v = `sapUiSmallMargin`
        )->a( n = `wrap`
              v = `Wrap` ).

    CLEAR temp1.
    INSERT `Regal` INTO TABLE temp1.
    INSERT `Stapler` INTO TABLE temp1.
    INSERT `LKWbeladen` INTO TABLE temp1.
    INSERT `LKWausladen` INTO TABLE temp1.
    INSERT `Lagereinlagern` INTO TABLE temp1.
    INSERT `Lagerauslagern` INTO TABLE temp1.
    INSERT `umpacken` INTO TABLE temp1.

    temp3 = temp1.

    LOOP AT temp3 INTO icon.

      CLEAR temp4.
      INSERT icon INTO TABLE temp4.
      icons->tag( `Button`
          )->a( n = `icon`
                v = |sap-icon://my-icons/{ icon }|
          )->a( n = `text`
                v = icon
          )->a( n = `class`
                v = `sapUiTinyMarginEnd`
          )->a( n = `press`
                v = client->_event( val = `ICON` t_arg = temp4 ) ).
    ENDLOOP.

    " 2. the row colours and 3. the column-sort header

    table = page->ele( `Table`
        )->a( n = `items`
              v = client->_bind( t_row )
        )->a( n = `class`
              v = `sapUiSmallMargin` ).


    columns = table->ele( `columns` ).
    columns->ele( `Column`
        )->tag( `Link`
            )->a( n = `text`
                  v = `Handling Unit`
            )->a( n = `class`
                  v = `customerColSort`
            )->a( n = `press`
                  v = client->_event( `SORT` ) ).
    columns->ele( `Column` )->tag( `Text` )->a( n = `text` v = `Product` ).
    columns->ele( `Column` )->tag( `Text` )->a( n = `text` v = `Quantity` ).


    item = table->ele( `items`
        )->ele( `ColumnListItem` ).
    " writeToDom puts data-color="<key>" on the tr - css/style.css colours it
    item->ele( `customData`
        )->tag( n  = `CustomData`
                ns = `core`
            )->a( n = `key`
                  v = `color`
            )->a( n = `value`
                  v = `{COLOR}`
            )->a( n = `writeToDom`
                  v = `{= ${COLOR} !== '' }` ).

    cells = item->ele( `cells` ).
    cells->tag( `Text` )->a( n = `text` v = `{HU}` ).
    cells->tag( `Text` )->a( n = `text` v = `{PRODUCT}` ).
    cells->tag( `ObjectNumber` )->a( n = `number` v = `{QUANTITY}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

  METHOD on_event.
        DATA temp1 TYPE xsdboolean.

    CASE client->get( )-event.
      WHEN `ICON`.
        client->message_toast_display( |sap-icon://my-icons/{ client->get_event_arg( ) }| ).
      WHEN `SORT`.

        temp1 = boolc( descending = abap_false ).
        descending = temp1.
        " the bound table travels back with the answer - no redisplay
        sort_rows( ).
    ENDCASE.

  ENDMETHOD.

  METHOD sort_rows.

    IF descending = abap_true.
      SORT t_row BY hu DESCENDING.
    ELSE.
      SORT t_row BY hu ASCENDING.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
