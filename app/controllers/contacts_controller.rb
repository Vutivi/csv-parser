require 'csv'

class ContactsController < ActionController::Base
  def parse_csv; end

  def csv_parsed
    headers = %i[Name Cellphone Type]

    csv = CSV.generate(headers: true) do |csv|
      csv << headers
      CSV.foreach(params[:contact][:file].tempfile, headers: true, col_sep: ',') do |row|
        is_client = row[2]&.to_s&.downcase&.starts_with?('ear') || row[0]&.to_s&.downcase&.starts_with?('ear')

        if is_client
          contact = []
          if row[12]&.rstrip.to_i > 9
            contact = row[12]&.gsub(/[^0-9A-Za-z]/, '')
          elsif row[7]&.rstrip.to_i > 9
            contact = row[7]&.gsub(/[^0-9A-Za-z]/, '')
          end

          if contact.length > 9
            csv << ["#{row[2].split(' ')[1]} #{row[2].split(' ')&.third}", contact&.last(9)&.insert(0, '+27'),
                    check_user_type(row[2])]
          end
        end
      end
    end

    send_data csv, type: 'text/csv; charset=utf-8; header=present',
                   disposition: 'attachment; filename=liftsearch_contacts_campaign_1.csv'
  end

  def check_user_type(name)
    if name.include?('_o')
      'occassional'
    elsif name.include?('_r')
      'regular'
    elsif name.include?('_c')
      'customer'
    end
  end
end
