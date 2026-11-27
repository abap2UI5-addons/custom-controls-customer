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
    TYPES ty_t_row TYPE STANDARD TABLE OF ty_s_row WITH EMPTY KEY.

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

    me->client = client.
    IF client->check_on_init( ).
      t_row = VALUE #( ( hu = `1000001` product = `Pallet A` quantity = 40 color = `grey_2` )
                       ( hu = `1000002` product = `Pallet B` quantity = 12 color = `red_2` )
                       ( hu = `1000003` product = `Box C`    quantity = 3  color = `` )
                       ( hu = `1000004` product = `Box D`    quantity = 7  color = `grey_4` ) ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.

  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " customerApp scopes the rules of css/style.css that must not reach the
    " other apps on the page
    DATA(root) = view->ele( n  = `View`
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

    DATA(page) = root->ele( `Page`
        )->a( n = `title`
              v = `Customer example - icons, row colours, column sort` ).

    " loads the icon font, the icon names and the stylesheet - before the
    " controls that use them
    z2ui5_cl_ccc=>render( page ).

    " 1. the icon font: sap-icon://my-icons/<name>
    DATA(icons) = page->ele( `HBox`
        )->a( n = `class`
              v = `sapUiSmallMargin`
        )->a( n = `wrap`
              v = `Wrap` ).
    LOOP AT VALUE string_table( ( `Regal` ) ( `Stapler` ) ( `LKWbeladen` ) ( `LKWausladen` )
                                ( `Lagereinlagern` ) ( `Lagerauslagern` ) ( `umpacken` ) ) INTO DATA(icon).
      icons->tag( `Button`
          )->a( n = `icon`
                v = |sap-icon://my-icons/{ icon }|
          )->a( n = `text`
                v = icon
          )->a( n = `class`
                v = `sapUiTinyMarginEnd`
          )->a( n = `press`
                v = client->_event( val = `ICON` t_arg = VALUE #( ( icon ) ) ) ).
    ENDLOOP.

    " 2. the row colours and 3. the column-sort header
    DATA(table) = page->ele( `Table`
        )->a( n = `items`
              v = client->_bind( t_row )
        )->a( n = `class`
              v = `sapUiSmallMargin` ).

    DATA(columns) = table->ele( `columns` ).
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

    DATA(item) = table->ele( `items`
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
    DATA(cells) = item->ele( `cells` ).
    cells->tag( `Text` )->a( n = `text` v = `{HU}` ).
    cells->tag( `Text` )->a( n = `text` v = `{PRODUCT}` ).
    cells->tag( `ObjectNumber` )->a( n = `number` v = `{QUANTITY}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

  METHOD on_event.

    CASE client->get( )-event.
      WHEN `ICON`.
        client->message_toast_display( |sap-icon://my-icons/{ client->get_event_arg( ) }| ).
      WHEN `SORT`.
        descending = xsdbool( descending = abap_false ).
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
