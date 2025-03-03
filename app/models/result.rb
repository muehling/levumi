class Result < ApplicationRecord
  include Averages

  belongs_to :student
  belongs_to :assessment
  validate :similar_within_last_ten_seconds # block posting of results for 10 seconds (some tests still do that)

  #Wochennummer-Format des Testungsdatum zur Zusammenfassung von Ergebnissen einer Woche generieren und speichern
  before_save do |result|
    unless result.test_date.nil?
      result.test_week =
        Date.commercial(result.test_date.to_date.year, result.test_date.to_date.cweek)
    else
      result.test_week = nil
    end
  end

  # Schattenkopie anlegen. falls Result-Objekt nicht zur Beispielklasse gehört, nicht leer ist und länger als 24h in der Datenbank (sonst vermutlich einfach fehlerhafte Messung).
  before_destroy do |result|
    if (!result.test_date.nil? && result.test_date < Date.today && !result.assessment.group.demo)
      student = ShadowStudent.find_by_original_id(result.student_id)
      student = result.student.create_shadow if student.nil?
      student.shadow_results.create(
        shorthand: result.assessment.test.shorthand,
        version: result.assessment.test.version,
        group: result.assessment.group.id,
        test_date: result.test_date,
        test_week: result.test_week,
        views: result.views,
        report: result.report,
        data: result.data
      )
    end
  end

  #JSON Export, nur relevante Attribute übernehmen.
  def as_json(options = {})
    json = super(except: %i[created_at updated_at])
  end

  #Textdarstellung für CSV Export
  def as_csv(for_user)
    start = "\"#{id}\","
    unless for_user
      ids = GroupShare.where(group_id: self.student.group.id).order(owner: :desc).pluck(:user_id)
      types = User.find(ids).pluck(:account_type)
      start += "\"#{ids.join(',')}\",\"#{types.join(',')}\","
    end
    test_timestamp = "#{test_date} #{created_at.strftime('%H:%M:%S')}"
    start +=
      "\"#{student.id}\",\"#{student.login}\",\"#{assessment.group_id}\",\"#{student.gender.nil? ? 'NA' : student.gender}\",\"#{student.birthmonth.nil? ? 'NA' : student.birthmonth}\",\"#{student.sen.nil? ? 'NA' : student.sen}\",\"#{student.tag_list}\",\"#{assessment.test_id}\",\"#{test_timestamp}\",\"#{test_week}\","
    res = ''
    if self.data.kind_of?(Array)
      self.data.each do |d|
        res = res + start

        # temporary fix - substitute all `\"` with `'`, lest the exported csv is broken
        d.each { |k, v| res = res + '"' + v.to_s.tr('\\"', "'") + '",' }
        res = res.slice(0, res.length - 1) + "\n" #Letztes Komma entfernen und newline anhängen
      end
    end
    return res
  end

  #Spaltenbezeichner für CSV-Export, nimmt an, dass alle Result-Objekte eines Tests ein einheitliches Format haben!
  def csv_header(for_user)
    res = '"Ergebnis_ID",'
    res += '"User_ID","User_Typ",' unless for_user
    res +=
      '"Kind_ID","Kind_Login","Klassen_ID","Geschlecht","Geburtsdatum","SPF","Tags","Test_ID","Testdatum","Testwoche"'
    self.data[0].each { |k, v| res = res + ',"' + k + '"' } if self.data.size > 0
    return res
  end

  #Eintrag 'trend' aus 'support' zurückliefern, falls vorhanden => Security-Check für fehlerhafte Result-Objekte
  def get_trend
    report.nil? || report['trend'].nil? ? 0 : report['trend'].to_i
  end

  #Eintrag 'items' aus 'support' zurückliefern, falls vorhanden => Security-Check für fehlerhafte Result-Objekte
  def get_support_items
    if report.nil? || report['negative'].nil?
      []
    else
      report['negative'].kind_of?(Array) ? report['negative'] : [report['negative']]
    end
  end
end

private

def similar_within_last_ten_seconds
  if Result
       .where(student_id: self.student_id, assessment_id: self.assessment_id)
       .where('created_at >= ?', 10.seconds.ago)
       .exists?
    errors.add(:base, 'A result for this test/student has been posted in the last 10 seconds.')
  end
end
