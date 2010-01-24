# Czech translation file for standard Rails internationalization
# See www.rails-i18n.org for more information about Rails i18n 
# 
# NOTE: In real world, you would obviously split this file into more pieces and load them separately
# 
# Translation by Karel Minařík (karmi@karmi.cz)

{ :'cz' => {

    # Static texts
    :locale         => 'Idioma',
    :switch_locale  => 'Cambiar Idioma:',
    :hello_world    => 'Hola Mundo!',
    :good_bye       => 'Adios!',

    # ActiveSupport
    :support => {
      :array => {
        :words_connector => ', ',
        :two_words_connector => ' y ',
        :last_word_connector => ' y '
      }
    },

    # Date
    :date => {
      :formats => {
        :default => "%d. %m. %Y",
        :short   => "%d %b",
        :long    => "%B %d, %Y",
      },
      :day_names         => %w{Domingo Lunes Martes Miercoles Jueves Viernes Sabado},
      :abbr_day_names    => %w{Do Lu Ma Mi Ju Vi Sa},
      :month_names       => %w{~ Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre},
      :abbr_month_names  => %w{~ Ene Feb Mar Abr May Jun Jul Ago Sep Oct Nov Dic},
      :order             => [:day, :month, :year]
    },
  time:
    formats:
      default: "%a, %d %b %Y %H:%M:%S %z"
      short: "%d %b %H:%M"
      long: "%B %d, %Y %H:%M"
    am: "am"
    pm: "pm"
    # Time
    :time => {
      :formats => {
        :default => "%a, %d %b %Y %H:%M:%S %z",
        :short   => "%d %b %H:%M",
        :long    => "%B %d, %Y %H:%M",
      },
      :am => 'am',
      :pm => 'pm'
    },

    # Numbers
    :number => {
      :format => {
        :precision => 3,
        :separator => '.',
        :delimiter => ','
      },
      :currency => {
        :format => {
          :unit => '$',
          :precision => 2,
          :format    => '%n %u',
          :separator => ",",
          :delimiter => " ",
        }
      },
      :human => {
        :format => {
          :precision => 1,
          :delimiter => ''
        },
       :storage_units => {
         :format => "%n %u",
         :units => {
           :byte => "B",
           :kb   => "KB",
           :mb   => "MB",
           :gb   => "GB",
           :tb   => "TB",
         }
       }
      },
      :percentage => {
        :format => {
          :delimiter => ''
        }
      },
      :precision => {
        :format => {
          :delimiter => ''
        }
      }
    },

    # Distance of time ... helper
    # NOTE: In Czech language, these values are different for the past and for the future. Preference has been given to past here.
    :datetime => {
      :distance_in_words => {
        :half_a_minute => 'medio minuto',
        :less_than_x_seconds => {
          :one => 'menos de un segundo',
          :other => 'menos de {{count}} segundos'
        },
        :x_seconds => {
          :one => 'un segundo',
          :other => '{{count}} segundos'
        },
        :less_than_x_minutes => {
          :one => 'menos de un minuto',
          :other => 'menos de {{count}} minutos'
        },
        :x_minutes => {
          :one => 'un minuto',
          :other => '{{count}} minutos'
        },
        :about_x_hours => {
          :one => 'como una hora',
          :other => 'como {{count}} horas'
        },
        :x_days => {
          :one => 'un día',
          :other => '{{count}} días'
        },
        :about_x_months => {
          :one => 'como un mes',
          :other => 'como {{count}} meses'
        },
        :x_months => {
          :one => 'un mes',
          :other => '{{count}} meses'
        },
        :about_x_years => {
          :one => 'como un año',
          :other => 'como {{count}} años'
        },
        :over_x_years => {
          :one => 'mas de un año',
          :other => 'mas de {{count}} años'
        }
      }
    },

    # ActiveRecord validation messages
    :activerecord => {
      :errors => {
        :messages => {
          :inclusion           => "no se incluye en la lista",
          :exclusion           => "está reservado",
          :invalid             => "es inválido",
          :confirmation        => "no matiza con la confirmación",
          :accepted            => "tiene que aceptarse",
          :empty               => "no puede dejarse vacío",
          :blank               => "no puede dejarse en blanco", # alternate formulation: "is required"
          :too_long            => "es demasiado largo (max. {{count}} caracteres)",
          :too_short           => "es demasiado corto (min. {{count}} caracteres)",
          :wrong_length        => "no es de la longitud correcta (debe ser de {{count}} caracteres)",
          :taken               => "ya se ha ocupado",
          :not_a_number        => "no es un número",
          :greater_than        => "debe ser mayor que {{count}}",
          :greater_than_or_equal_to => "debe ser {{count}} o mayor",
          :equal_to            => "debe ser igual a {{count}}",
          :less_than           => "debe ser menos que {{count}}",
          :less_than_or_equal_to    => "debe ser {{count}} o menos",
          :odd                 => "debe ser impar",
          :even                => "debe ser par"
        },
        :template => {
          :header   => {
            :one => "Hubo un error guardando {{model}} y no se pudo guardar",
            :other => "Surgieron {{count}} errores guardando {{model}} y por eso no se pudo guardar."
          },
          :body  => "Las siguientes casillas no contienen datos válidos:"
        }
        :models=>{
        	:account							=> "Cuenta"
        	:category							=> "Categoría"
        	:entity							=> "Entidad"
        	:entry							=> "Transacción"
        	:inventory							=> "Inventario"
        	:movement							=> "Transacción"
        	:preference							=> "Preferencia"
        	:price							=> "Precio"
        	:price_group							=> "Grupo de Precios"
        	:right							=> "Derecho"
        	:role							=> "Responsabilidades"
        	:user							=> "Usuario"
        	:serial							=> "Número de Serie"
        	:state							=> "Departamento"
        	:subscription							=> "Subscripción"
        	:unit							=> "Unidad"
        	:warranty							=> "Garantía"
        }
      }
    }
  }
}
