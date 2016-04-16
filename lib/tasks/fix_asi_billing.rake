namespace :fix do
  task :fix_asi_billing, [:debug] => :environment do |t, args|
    args.with_defaults(:debug => 'true')
    jobs = MyServiceCall.with_billing_status(:paid, :cleared, :collected_by_employee, :overdue).order('id ASC')

    puts("\033[42;33m##### Running in debug mode #####\033[0m \n") if args.debug == 'true'
    puts("\033[46;31m##### Running in production mode #####\033[0m \n") unless args.debug == 'true'

    job_count = 0
    jobs.each do |job|

      props = { amount:      -(job.total_price + (job.total_price * (job.tax / 100.0))),
                ticket:      job,
                agreement:   job.customer.agreements.first,
                event:       job.events.where(type: ScCollectedByEmployeeEvent).first,
                description: "#{job.payment_type} payment collected by #{job.collector.name} (system fix)" }

      props[:account] = job.customer.account if args.debug =='true'

      case job.payment_type
        when 'cash'
          if job.entries.where(type: CashPayment).size == 0
            e = CashPayment.new(props)
            job.customer.account.entries << e unless args.debug =='true'
          end
        when 'cheque'
          if job.entries.where(type: ChequePayment).size == 0
            e = ChequePayment.new(props)
            job.customer.account.entries << e unless args.debug  =='true'
          end
        when 'credit_card'
          if job.entries.where(type: CreditPayment).size == 0
            e = CreditPayment.new(props)
            job.customer.account.entries << e unless args.debug =='true'
          end
        when 'amex_credit_card'
          if job.entries.where(type: AmexPayment).size == 0
            e = AmexPayment.new(props)
            job.customer.account.entries << e unless args.debug =='true'
          end
        else
          raise "Job without a payment type: #{job.id}"

      end
      unless e.nil?
        puts "Job #{job.id}, #{job.payment_type}: #{job.inspect}"
        puts "\t Entry (valid=#{e.valid?}): #{e.inspect}"
        puts "\t \033[46;31mINVALID\033[0m #{e.inspect}" unless e.valid?
        puts "#{e.inspect}" if e.valid?
        job_count += 1
      end

    end

    puts "\n\033[42;33m#### Total Jobs Processed: #{job_count} #####\033[0m"


  end
end