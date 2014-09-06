(function($, molgenis) {
	"use strict";
	
	function getAPrioriRisk(trisomyType, gestAge, matAge) {
		$.ajax({
			type : 'GET',
			url : molgenis.getContextUrl() + '/getAPrioriRisk/' + trisomyType + '/'+ gestAge + '/' + matAge,
			success : function(text) {
				$('#apriori').val(text);
				if ("?" == text) {
					$('#apriori').attr('style', 'background-color:#d9534f');
				} else {
					$('#apriori').attr('style', 'background-color:#dff0d8');
				}
			}
		});
	}

	function getRisk(llim, ulim, varcof, zscore, apriori) {
		$.ajax({
			type : 'GET',
			url : molgenis.getContextUrl() + '/getRisk/' + llim + '/' + ulim + '/' + '/' + varcof + '/' + zscore + '/' + apriori,
			success : function(risk) {
				$('#trisomyChance').html(risk);
				$('#showResult').attr('style', 'display:block');
				$('#apriori').attr('style', '');
			}
		});
	}

	$(function() {
		$('#calculate-risk-btn').click(function(e) {
			e.preventDefault();
			e.stopPropagation();

			$('#showResult').attr('style', 'display:none');
			if ($('#llim').val() < 0 || 100 < $('#llim').val()) {
				molgenis.createAlert([ {
					'message' : 'Lower limit fetal DNA must have a value between 0 and 100%.'
				} ], 'error');
			} else if ($('#ulim').val() < 0 || 100 < $('#ulim').val()) {
				molgenis.createAlert([ {
					'message' : 'Upper limit fetal DNA must have a value between 0 and 100%.'
				} ], 'error');
			} else if ($('#varcof').val() < 0 || 100 < $('#varcof').val()) {
				molgenis.createAlert([ {
					'message' : 'Variation coefficient must have a value between 0 and 100%.'
				} ], 'error');
			} else if ($('#zscore').val() < -5 || 40 < $('#zscore').val()) {
				molgenis.createAlert([ {
					'message' : 'Observed Z score must have a value -5 and 40.'
				} ], 'error');
			} else if ("" === $('#apriori').val() || $('#apriori').val() <= 0) {
				molgenis.createAlert([ {
					'message' : 'A priori risk of trisomy must have a positive value.'
				} ], 'error');
			} else {
				$('#showResult').attr('style', 'display:block');
				var apriori = 1 / $('#apriori').val();
				$('#results').html(getRisk($('#llim').val(), $('#ulim').val(), $('#varcof').val(), $('#zscore').val(), apriori));

				$('#llimResult').html($('#llim').val());
				$('#ulimResult').html($('#ulim').val());
				$('#varcofResult').html($('#varcof').val());
				$('#zscoreResult').html($('#zscore').val());
				$('#aprioriResult').html($('#apriori').val());
			}
		});
		
		$('#calculate-a-priori-risk-btn').click(function(e) {
			e.preventDefault();
			e.stopPropagation();
			
			if ($('#gestAge').val() < 10 || 40 < $('#gestAge').val()) {
				molgenis.createAlert([ {
					'message' : 'Gestational age must have a value between 10 and 40.'
				} ], 'error');
				
				$('#apriori').val('');
				$('#apriori').attr('style', 'background-color:#fff');
			} else if ($('#matAge').val() < 20 || 44 < $('#matAge').val()) {
				molgenis.createAlert([ {
					'message' : 'Maternal age must have a value between 20 and 44.'
				} ], 'error');
				
				$('#apriori').val('');
				$('#apriori').attr('style', 'background-color:#fff');
			} else {
				getAPrioriRisk($('#trisomyType .active').val(), $('#gestAge').val(), $('#matAge').val());
			}
		});
	});
}($, window.top.molgenis = window.top.molgenis || {}));
