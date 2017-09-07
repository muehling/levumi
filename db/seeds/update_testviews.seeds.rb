active_tests = Test.where(:archive => false)
items_to_update_preparation = Item.where(:test_id => active_tests, :itemtype => -1)
items_to_update_testitems = Item.where(:test_id => active_tests, :itemtype => 0)
items_to_update_enditems = Item.where(:test_id => active_tests, :itemtype => 1)

i = 0
while i< items_to_update_preparation.size
  items_to_update_preparation[i].itemview = "items/userbased/preparationUser"
  items_to_update_preparation[i].save
  i = i+1
end

i = 0
while i< items_to_update_testitems.size
  items_to_update_testitems[i].itemview = "items/userbased/testItemUser"
  items_to_update_testitems[i].save
  i = i+1
end

i = 0
while i< items_to_update_enditems.size
  items_to_update_enditems[i].itemview = "items/userbased/endItemUser"
  items_to_update_enditems[i].save
  i = i+1
end