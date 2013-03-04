module PostingRulesHelper
  def posting_rule_option(klass)

    [
        klass.name.titleize,
        klass.name.underscore,
    ]

  end

  def posting_rule_types
    Rails.logger.debug { "Need to reload all subclasses in dev mode" + ProfitSplit.name }
    PostingRule.subclasses.map { |subclass| posting_rule_option(subclass) }
  end

  def rate_types
    res = []
    @posting_rule.rate_types.each do |type|
      res << [t("posting_rule.rate_types.#{type}"), type]
    end
    res
  end

end
