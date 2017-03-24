class TestDictation < Test
#Return lenghth and lead time
  def len_info
    return "#{time} Sekunden, max. #{len} Items"
  end
#Return type info
  def type_info
    return "Diktat"
  end
#Return which view should be chosen
  def view_info
    return "TestDiktatNormal"
  end

end
