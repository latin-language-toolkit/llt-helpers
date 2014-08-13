module LLT
  module Helpers
    module Terminology
      class << self
        def term_for(key)
          FULL_TABLE[key.to_sym]
        end

        # rename, scrap term
        def key_term_for(key)
          KEY_TABLE[key.to_sym]
        end

        def value_term_for(key, value)
          t = VALUE_TABLE[key]
          if t.nil?
            # tries to normalize the key
            k = key_term_for(key)

            # hacky solution to normalize inflection class integers
            return value.to_i if inflection_class_number_as_string?(key, value)

            t = VALUE_TABLE[k]
            return value unless t
          end
          t[val_to_sym_or_integer(value)] || value
        end
        alias :value_for :value_term_for

        def inflection_class_number_as_string?(key, value)
          key == inflection_class && value.kind_of?(String) && value.match(/^\d*$/)
        end

        def val_to_sym_or_integer(val)
          # Normalizes strings to symbols or integers, but leaves fixnums intact
          case val
          when /^\d*$/ then val.to_i
          when String  then val.to_sym
          else val
          end
        end

        def values_for(key_term, exclude: nil)
          v = VALUE_TABLE[key_term_for(key_term)]
          v ? v.keys : []
        end

        def norm_values_for(key_term, format: DEFAULT_FORMAT[key_term])
          NORM_VALUES[key_term].map { |values| send(values.first, format) }
        end

        def method_missing(meth, *args, &blk)
          meth
        end

        # implement to_ary everytime you do crazy method_missing stuff.
        # #flatten will bite you otherwise!
        def to_ary
          nil
        end

        # Keywords

        def inflection_class
          :inflection_class
        end

        def tempus
          :tempus
        end

        def casus
          :casus
        end

        def type
          :type
        end

        def numerus
          :numerus
        end

        def sexus
          :sexus
        end

        def noe
          :number_of_endings
        end

        def modus
          :modus
        end

        def genus
          :genus
        end

        def persona
          :persona
        end

        def deponens
          :deponens
        end

        def degree
          :comparatio
        end

        DEFAULT_FORMAT = {
          casus:   :numeric,
          numerus: :numeric,
          tempus:  :abbr,
          sexus:   :abbr,
          modus:   :abbr,
          type:    :full,
          genus:   :abbr,
          persona: :numeric,
          degree:  :full
        }

        # Convenience Methods

        def self.create_three_way_getter_methods(abbr, full, i, type)
          class_eval <<-STR
            def #{full}(arg = :#{DEFAULT_FORMAT[type]})
              case arg
              when :numeric then #{i + 1}
              when :abbr    then :#{abbr}
              when :full    then :#{full}
              when :camelcase then :#{camelcased(full)}
              end
            end
            alias :#{abbr} :#{full}
          STR
        end

        def self.camelcased(str)
          str.to_s.split("_").map(&:capitalize).join
        end

        NORM_VALUES = { casus:   [[:nom, :nominativus], [:gen, :genetivus], [:dat, :dativus], [:acc, :accusativus], [:voc, :vocativus], [:abl, :ablativus]],
                        numerus: [[:sg, :singularis], [:pl, :pluralis]],
                        tempus:  [[:pr, :praesens], [:impf, :imperfectum], [:fut, :futurum], [:pf, :perfectum], [:pqpf, :plusquamperfectum], [:fut_ex, :futurum_exactum]],
                        sexus:   [[:m, :masculinum], [:f, :femininum], [:n, :neutrum]],
                        modus:   [[:ind, :indicativus], [:con, :coniunctivus], [:imp, :imperativum], [:part, :participium], [:inf, :infinitivum], [:gerundium, :gerundium], [:gerundivum, :gerundivum]],
                        type:    [[:noun, :noun], [:adj, :adjective], [:verb, :verb]],#, [:gerundive, :gerundive], [:gerund, :gerund]],
                        genus:   [[:act, :activum], [:pass, :passivum]],
                        persona: [[:first, :first], [:second, :second], [:third, :third]],
                        degree:  [[:pos, :positivus], [:comp, :comparativus], [:sup, :superlativus]]
        }

        NORM_VALUES.each do |type, getters|
          getters.each_with_index do |(abbr, full), i|
            create_three_way_getter_methods(abbr, full, i, type)
          end
        end
      end

      kt = { inflection_class => %i{ inflection_class inflectable_class iclass itype },
             tempus => %i{ tempus tense },
             casus => %i{ casus case },
             numerus => %i{ numerus },
             modus => %i{ mood modus },
             sexus => %i{ sexus gender },
             genus => %i{ genus diathesis voice },
             type  => %i{ type pos },
             noe   => %i{ number_of_endings noe },
             nom(:abbr) => %i{ nominative nom },
             deponens => %i{ dep deponens },
             degree => %i{ comparison comparatio degree comp }
      }

      KEY_TABLE = kt.each_with_object({}) do |(norm_term, terms), h|
        terms.each { |term| h[term] = norm_term }
      end


      vt = {
        tempus => { pr => %i{ present praesens pr },
                    pf => %i{ perfect perfectum pf },
                    fut => %i{ future futurum fut },
                    pqpf => %i{ pluperfect plusquamperfectum pqpf },
                    fut_ex => %i{ future_perfect futurum_exactum fut_ex },
                    impf => %i{ imperfect imperfectum impf }, },
        casus  => { nom => %i{ nom nominative nominativus } + [1],
                    gen => %i{ gen genetive   genetivus   } + [2],
                    dat => %i{ dat dative     dativus     } + [3],
                    acc => %i{ acc accusative accusativus } + [4],
                    voc => %i{ voc vocative   vocativus   } + [5],
                    abl => %i{ abl ablative   ablativus   } + [6], },
        numerus => { sg => %i{ singularis singular } + [1],
                     pl => %i{ pluralis   plural   } + [2], },
        genus   => { activum  => %i{  activum act   },
                     passivum => %i{  passivum pass }, },
        modus   => { indicativus  => %i{ indicativus  ind  indicative  },
                     coniunctivus => %i{ coniunctivus con  conjunctive subjunctive },
                     imperativus  => %i{ imperativus  imp  imperativum },
                     participium  => %i{ participium  part participle  },
                     gerundium =>   %i{  gerundium  gerund },
                     gerundivum =>  %i{  gerundivum gerundive },
                     infinitivum => %i{  infinitivum inf infinitive },
                     supinum =>     %i{  supinum sup }, },
        sexus   => { m => %i{  m masc masculine masculinum },
                     f => %i{  f fem  feminine  femininum  },
                     n => %i{  n neut neuter    neutrum    }, },
        type    => { noun => %i{ noun substantive },
                     adj => %i{ adj adjective },
                     verb => %i{ verb }, },
                     # ...
        noe     => { 1 => %i{ one_ending },
                     2 => %i{ two_endings },
                     3 => %i{ three_endings }, },
        degree => { positivus => %i{ pos positivus positive },
                     comparativus => %i{ comp comparative comparativus },
                     superlativus => %i{ sup superlative superlativus } }
      }

      VALUE_TABLE = vt.each_with_object({}) do |(key_term, hash), h|
        nh = hash.each_with_object({}) do |(norm_term, values), nested_h|
          values.each { |val| nested_h[val] = norm_term }
        end
        h[key_term] = nh
      end

      FULL_TABLE = KEY_TABLE.merge(VALUE_TABLE.values.inject({}) { |new, old| new.merge(old) })
    end
  end
end
