*&---------------------------------------------------------------------*
*&  Include           ZI_DELIVERY_DATA_DECLARATION
*&---------------------------------------------------------------------*
*--- Class declaration ---------------------------------------------------
*-------------------------------------------------------------------------
data: cl_delivery type ref to zcl_delivery.

* Declaration of Internal tables and work areas
types : begin of ty_final,
          table type char40,
        end of ty_final,
        begin of ty_tables,
          name  type dd02v-tabname,
          table type char40,
        end of ty_tables.

data: gt_final  type ty_final occurs 0,
      gw_final  type ty_final,
      gt_tables type ty_tables occurs 0,
      gw_tables type ty_tables,
      gt_return like ddshretval occurs 0,
      gw_return like ddshretval,
      gt_excl   type vimexclfun occurs 0,
      gw_excl   type vimexclfun,
      gv_end    type char1.
