create or replace trigger payment_b_iu_api
  before insert or update
  on payment 
begin
  payment_api_pack.is_changes_through_api();
end payment_b_iu_api;
/
