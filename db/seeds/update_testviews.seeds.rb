#Updatetet alle Views der Items von allen lehrerseitigen Tests
active_tests = Test.where(:archive => false, :student_access => false)
items_to_update_all= Item.where(:test_id => active_tests)

i = 0
while i< items_to_update_all.size
  itemtype = items_to_update_all[i].itemtype
  case itemtype
    when -1
      items_to_update_all[i].itemview = "items/userbased/preparationUser"
      items_to_update_all[i].save
      i = i+1
    when 0
      items_to_update_all[i].itemview = "items/userbased/testItemUser"
      items_to_update_all[i].save
      i = i+1
    else
      items_to_update_all[i].itemview = "items/userbased/endItemUser"
      items_to_update_all[i].save
      i = i+1
  end
end


###Kann gegebenenfalls wieder raus
#Updatet die Views der Tatstaturschulungsitems
active_tests = Test.where(:archive => false, :name => 'Tastaturschulung')
items_to_update_all= Item.where(:test_id => active_tests)

i = 0
while i< items_to_update_all.size
  itemtype = items_to_update_all[i].itemtype
  case itemtype
    when -28
      items_to_update_all[i].itemview = "items/studentbased/abtipptest/1hallo"
      items_to_update_all[i].save
      i = i+1
    when -27
      items_to_update_all[i].itemview = "items/studentbased/abtipptest/2enter"
      items_to_update_all[i].save
      i = i+1
    when -26
      items_to_update_all[i].itemview = "items/studentbased/abtipptest/3repeat_sound"
      items_to_update_all[i].save
      i = i+1
    when -25
      items_to_update_all[i].itemview = "items/studentbased/abtipptest/4headphones"
      items_to_update_all[i].save
      i = i+1
    when -24
      items_to_update_all[i].itemview = "items/studentbased/abtipptest/5keyboard"
      items_to_update_all[i].save
      i = i+1
    when -23
      items_to_update_all[i].itemview = "items/studentbased/abtipptest/6backspace"
      items_to_update_all[i].save
      i = i+1
    when -22
      items_to_update_all[i].itemview = "items/studentbased/abtipptest/7delete_exercise"
      items_to_update_all[i].save
      i = i+1
    when -21
      items_to_update_all[i].itemview = "items/studentbased/abtipptest/8umlaut"
      items_to_update_all[i].save
      i = i+1
    when -20
      items_to_update_all[i].itemview = "items/studentbased/abtipptest/9umlaut_task"
      items_to_update_all[i].save
      i = i+1
    when -19
      items_to_update_all[i].itemview = "items/studentbased/abtipptest/10umlaut_exercise1"
      items_to_update_all[i].save
      i = i+1
    when -18
      items_to_update_all[i].itemview = "items/studentbased/abtipptest/11umlaut_exercise2"
      items_to_update_all[i].save
      i = i+1
    when -17
      items_to_update_all[i].itemview = "items/studentbased/abtipptest/12umlaut_exercise3"
      items_to_update_all[i].save
      i = i+1
    when -16
      items_to_update_all[i].itemview = "items/studentbased/abtipptest/13umlaut_praise"
      items_to_update_all[i].save
      i = i+1
    when -15
      items_to_update_all[i].itemview = "items/studentbased/abtipptest/14ß"
      items_to_update_all[i].save
      i = i+1
    when -14
      items_to_update_all[i].itemview = "items/studentbased/abtipptest/15ß_task"
      items_to_update_all[i].save
      i = i+1
    when -13
      items_to_update_all[i].itemview = "items/studentbased/abtipptest/16ß_exercise1"
      items_to_update_all[i].save
      i = i+1
    when -12
      items_to_update_all[i].itemview = "items/studentbased/abtipptest/17ß_exercise2"
      items_to_update_all[i].save
      i = i+1
    when -11
      items_to_update_all[i].itemview = "items/studentbased/abtipptest/18ß_exercise3"
      items_to_update_all[i].save
      i = i+1
    when -10
      items_to_update_all[i].itemview = "items/studentbased/abtipptest/19capitalization"
      items_to_update_all[i].save
      i = i+1
    when -9
      items_to_update_all[i].itemview = "items/studentbased/abtipptest/20capitalization_task"
      items_to_update_all[i].save
      i = i+1
    when -8
      items_to_update_all[i].itemview = "items/studentbased/abtipptest/21capitalization_exercise1"
      items_to_update_all[i].save
      i = i+1
    when -7
      items_to_update_all[i].itemview = "items/studentbased/abtipptest/22capitalization_exercise2"
      items_to_update_all[i].save
      i = i+1
    when -6
      items_to_update_all[i].itemview = "items/studentbased/abtipptest/23capitalization_exercise3"
      items_to_update_all[i].save
      i = i+1
    when -5
      items_to_update_all[i].itemview = "items/studentbased/abtipptest/24thanks"
      items_to_update_all[i].save
      i = i+1
    when -4
      items_to_update_all[i].itemview = "items/studentbased/abtipptest/25typewrite_exercise"
      items_to_update_all[i].save
      i = i+1
    when -3
      items_to_update_all[i].itemview = "items/studentbased/abtipptest/26typewrite_levumi"
      items_to_update_all[i].save
      i = i+1
    when -2
      items_to_update_all[i].itemview = "items/studentbased/abtipptest/27typewrite_quitten"
      items_to_update_all[i].save
      i = i+1
    when -1
      items_to_update_all[i].itemview = "items/studentbased/abtipptest/28typewrite_baeume"
      items_to_update_all[i].save
      i = i+1
    else
      items_to_update_all[i].itemview = "items/studentbased/abtipptest/29finished"
      items_to_update_all[i].save
      i = i+1
  end
end
