---- Function: fn_get_stock_summary_data_by_facility(integer, integer, character varying, integer, character varying, integer, integer)
--
--DROP FUNCTION IF EXISTS fn_get_stock_summary_data_by_facility(integer, integer, character varying, integer, character varying, integer, integer);
--
--CREATE OR REPLACE FUNCTION fn_get_stock_summary_data_by_facility(IN in_program_id integer, IN in_period_id integer, IN in_field character varying, IN in_userid integer DEFAULT 0, IN in_product_code character varying DEFAULT 'ALL'::character varying, IN in_geographiczone_id integer DEFAULT 0, IN in_n integer DEFAULT 4)
--  RETURNS TABLE(r bigint, productcode character varying, shortname character varying, facilityid integer, facilityname character varying, quantityreceived integer, quantitydispensed integer, quantityrequested integer, quantityapproved integer, amc integer, stockinhand integer, quantityexpired integer, quantitydamaged integer, quantitylost integer, fillrate double precision, price numeric) AS
--$BODY$
--
--
--DECLARE
---- return values
--finalQuery VARCHAR;
---- temp
--i integer;
--t_period_id integer;
--t_start_date date;
--t_id integer; -- temp
--t_date date; -- temp2
--t_price numeric(20,2);
--t_product_id integer;
--t_li_id integer;
--t_program_id integer;
--t_geographiczone_id integer;
--t_parent_id integer;
--t_level_id integer;
--t_where_1 varchar;
--t_order_by_1 varchar;
--t_group_by_1 varchar;
--t_join_1 varchar;
--t_user_products varchar;
--t_periods varchar;
--t_tracer varchar;
--t_default varchar;
--t_sdp_level_id integer;
--t_schedule_id integer;
--t_field varchar;
--
--
--BEGIN
--t_where_1 = '';
--t_order_by_1 = '';
--t_group_by_1 = '';
--t_join_1 = '';
--t_user_products = '';
--t_periods = '';
--t_tracer = 't';
--t_default = 'DEFAULT_PRODUCTS';
--t_schedule_id = 0;
--t_field = 'xxx';
--
--
--if upper(in_field) ='DISPENSED' then t_field = 'quantitydispensed';   end if;
--if upper(in_field) ='RECEIVED' then t_field = 'quantityreceived';   end if;
--if upper(in_field) ='REQUESTED' then t_field = 'quantityrequested';   end if;
--if upper(in_field) ='APPROVED' then t_field = 'quantityapproved';   end if;
--if upper(in_field) ='AMC' then t_field = 'quantitydispensed';   end if;
--if upper(in_field) ='ONHAND' then t_field = 'stockinhand';   end if;
--if upper(in_field) iN ('EXPIRED','DAMAGED','LOST') then t_field = '(COALESCE(quantityexpired,0) + COALESCE(quantitylost,0) +  COALESCE(quantitydamaged,0))';   end if;
--if upper(in_field) ='FILLRATE' then t_field = 'quantitydispensed';   end if;
---- get ids ids are valid
--select id into t_product_id from products where lower(code) = lower(in_product_code);
--select id into t_program_id from programs where id = in_program_id;
--select id, processing_periods.startdate::date, scheduleid into t_period_id, t_start_date, t_schedule_id from processing_periods where id = in_period_id;
--
---- check null values
--t_period_id = COALESCE(t_period_id,0);
--t_program_id = COALESCE(t_program_id,0);
--t_product_id = COALESCE(t_product_id,0);
--t_schedule_id = COALESCE(t_schedule_id,0);
--
--
---- goegraphic zone
--if in_geographiczone_id <> 0 then
--select id, levelid, parentid into t_geographiczone_id, t_level_id, t_parent_id from geographic_zones where id = in_geographiczone_id;
--t_geographiczone_id = COALESCE(t_geographiczone_id,-1);
--t_parent_id = COALESCE(t_parent_id,-1);
--end if;
--
--t_geographiczone_id = COALESCE(t_geographiczone_id,0);
--t_parent_id = COALESCE(t_parent_id,0);
--
--if t_geographiczone_id = 0 THEN
--t_geographiczone_id = (select id from geographic_zones where COALESCE(parentid,0) = 0);
--t_geographiczone_id = COALESCE(t_geographiczone_id,0);
--end if;
--
--
---- proceed if ids arae valid
--if t_period_id > 0 and t_program_id > 0 and t_geographiczone_id >= 0 then
--
---- add program constraint
--t_where_1 = ' where r.programid = '||t_program_id;
--
---- add product contraint
--if in_product_code = 'ALL' then
--t_where_1 = t_where_1 || ' and p.tracer = '||quote_literal(t_tracer);
--else
--t_where_1 = t_where_1 || ' and p.code = '|| quote_literal(in_product_code);
--end if;
--
---- add users product constraint
--if in_userid > 0 THEN
--t_user_products = (select value from user_preferences where userid = in_userid and userpreferencekey = 'DEFAULT_PRODUCTS');
--t_user_products = COALESCE(t_user_products,'0');
--t_where_1 = t_where_1 || ' and p.id in ('|| t_user_products ||') ';
--end if;
--
--t_where_1 = t_where_1 || ' and pp.id = '|| t_period_id;
----t_where_1 = t_where_1 || ' and '||case when in_field||' >= 0';
--
---- set group by
--t_group_by_1 = '';
--
---- set order by clause
--t_order_by_1 = ' order by productcode, sn.name';
--
--
---- initialized
--i := 0;
--select currentprice into t_price from program_products where productid = t_product_id and programid = t_program_id;
--t_price = COALESCE(t_price,0);
---- not executed if in_nth is 0(current period)
--
--select max(levelid) into t_sdp_level_id from facility_types;
--t_sdp_level_id = COALESCE(t_sdp_level_id,0);
--
--
--finalQuery :=
--'
--SELECT
--rs.*
--FROM (
--SELECT
--ROW_NUMBER() OVER (PARTITION BY t.product_code order by '||t_field||' desc) AS r,
--t.*
--FROM
--(
--SELECT
--productcode product_code,
--sn.name short_name,
--f.id facility_id,
--f.name facility_name,
--COALESCE(quantityreceived,0)::int quantityreceived,
--COALESCE(case when ft.levelid = '|| t_sdp_level_id ||' then quantitydispensed else 0 end,0)::int quantitydispensed,
--COALESCE(quantityrequested,0)::int quantityrequested,
--COALESCE(quantityapproved,0)::int quantityapproved,
--COALESCE(amc,0)::integer amc,
--COALESCE(stockinhand,0)::integer stockinhand,
--COALESCE((select COALESCE(quantity,0) from requisition_line_item_losses_adjustments where requisitionlineitemid = li.id and type = ''EXPIRED''),0)::int quantityexpired,
--COALESCE((select COALESCE(quantity,0) from requisition_line_item_losses_adjustments where requisitionlineitemid = li.id and type = ''DAMAGED''),0)::int quantitydamaged,
--COALESCE((select COALESCE(quantity,0) from requisition_line_item_losses_adjustments where requisitionlineitemid = li.id and type = ''LOST''),0)::int quantitylost,
--case when COALESCE(quantityrequested,0) > 0 then (COALESCE(quantityrequested,0) - COALESCE(quantityapproved,0::double precision)) / COALESCE(quantityrequested,0)::double precision * 100 else 0 end fillrate,
--COALESCE((select currentprice from program_products where programid = r.programid and productid = p.id limit 1),0) price
--from requisition_line_items li
--INNER JOIN requisitions r ON li.rnrid = r.id
--INNER JOIN processing_periods pp ON pp.id = r.periodid
--INNER JOIN facilities f ON f.id = r.facilityid
--INNER JOIN facility_types ft ON f.typeid = ft.id
--INNER JOIN geographic_zones gz ON gz.id = f.geographiczoneid
--INNER JOIN products p ON li.productcode= p.code
--INNER JOIN programs pg ON r.programid = pg.id
--INNER JOIN program_products pgp ON pgp.programid = pg.id AND pgp.productid = p.id
--INNER JOIN facility_approved_products fap ON fap.programproductid = pgp.id AND fap.facilitytypeid = f.typeid
--LEFT  JOIN product_short_names sn ON sn.productid = p.id'||
--t_join_1 || t_where_1 || t_group_by_1 ||' ) t) rs where rs.r <= '||in_n ||' and '||t_field || ' > 0';
--
--end if;
--RETURN QUERY EXECUTE finalQuery;
--END;
--$BODY$
--  LANGUAGE plpgsql VOLATILE
--  COST 100
--  ROWS 1000;
--ALTER FUNCTION fn_get_stock_summary_data_by_facility(integer, integer, character varying, integer, character varying, integer, integer)
--  OWNER TO postgres;