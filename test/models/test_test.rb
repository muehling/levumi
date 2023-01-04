require 'test_helper'

class TestTest < ActionDispatch::IntegrationTest
  test 'Test.name' do
    t = tests(:writing_n1)
    assert_equal t.name, 'N1'
    t.update! archive: true
    assert_equal t.name, 'N1 (veraltet)'
  end

  test 'Test.full_name' do
    t = tests(:writing_n1)
    assert_equal t.full_name, 'Deutsch - Rechtschreibung - Wörter schreiben - N1'
  end

  test 'Test.info' do
    t = tests(:writing_n1)
    info = t.info
    assert_equal info[:level], 'N1'
    assert_equal info[:family], 'Wörter schreiben'
  end

  test 'Test.has_results' do
    t = tests(:writing_n1)
    assert_equal t.has_results, true

    t = tests(:writing_n2)
    assert_equal t.has_results, false
  end
end
