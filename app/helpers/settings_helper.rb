module SettingsHelper
  def default_settings
    {
      #Achtung: Evtl. nicht der einzige Ort an dem dieser Werte definiert werden! TODO: Lässt sich das lösen?
      'font_family' => 'Fibel Nord',
      'font_size' => 1,
      'display_timer' => false
    }
  end
end
