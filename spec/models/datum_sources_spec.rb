require 'spec_helper'

describe ( 'DatumSource model' ) {
  describe ( 'with valid data' ) {
    let ( :ds_lit_rate ) { DatumSource.find_by_admin_name( 'ds_lit_rate' ) }
    let ( :ds_pct_inet ) { DatumSource.find_by_admin_name( 'ds_pct_inet' ) }
    let ( :ds_fixed_monthly ) { DatumSource.find_by_admin_name( 'ds_fixed_monthly' ) }
    let ( :ds_fixed_monthly_gdp ) { DatumSource.find_by_admin_name( 'ds_fixed_monthly_gdp' ) }
    let ( :ds_consistency ) { DatumSource.find_by_admin_name( 'ds_consistency' ) }
    let ( :ds_population ) { DatumSource.find_by_admin_name( 'ds_population' ) }
    let ( :ds_gdp ) { DatumSource.find_by_admin_name( 'ds_gdp' ) }

    describe ( 'attributes' ) {
      subject { ds_pct_inet }

      it {
        should be_valid
      }

      it {
        should respond_to :admin_name
        should respond_to :public_name
      }

      it {
        should respond_to :default_weight
      }

      it {
        should respond_to :in_category_page
        should respond_to :in_sidebar
      }
    }

    describe ( 'with category' ) {
      let ( :cat_access ) { Category.find_by_name( 'Access' ) }

      it {
        ds_pct_inet.category.should eq( cat_access )
      }
    }

    describe ( 'with group' ) {
      let ( :grp_adoption ) { Group.find_by_admin_name( 'adoption' ) }

      it {
        ds_pct_inet.group.should eq( grp_adoption )
      }
    }

    describe ( 'min_max' ) {
      it {
        ds_lit_rate.min.should eq( 36.51840027 )
        ds_lit_rate.max.should eq( 94.2722 )
      }

      it {
        ds_pct_inet.min.should eq( 21.0 )
        ds_pct_inet.max.should eq( 30.8539009094 )
      }

      it {
        ds_fixed_monthly.min.should eq( 16.5671546612 )
        ds_fixed_monthly.max.should eq( 18.5729763195 )
      }

      it {
        ds_fixed_monthly_gdp.min.should eq( 0.00341114943653143 )
        ds_fixed_monthly_gdp.max.should eq( 0.00366048227586886 )
      }

      it {
        ds_consistency.min.should eq( 10.0 )
        ds_consistency.max.should eq( 10.0 )
      }

      it {
        ds_population.min.should eq( 74798599 )
        ds_population.max.should eq( 1344130000 )
      }

      it {
        ds_gdp.min.should eq( 4525.9486080335 )
        ds_gdp.max.should eq( 4525.9486080335 )
      }
    }
  }
}


