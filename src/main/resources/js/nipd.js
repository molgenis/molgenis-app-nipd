(function ($) {
    "use strict";

    ///////// Main form /////////

    function getInputFromForm() {
        return {
            lower: $('#llim').val(),
            upper: $('#ulim').val(),
            varcof: $('#varcof').val(),
            z: $('#zscore').val(),
            aPriori: $('#aPriori').val()
        };
    }

    function getRisk() {
        var dataFromForm = getInputFromForm();
        var aPrioriLookupData = $('#aPriori').data('lookupFormData');
        $.ajax({
            type: 'GET',
            url: '/scripts/niptRisk/run',
            data: dataFromForm,
            dataType: 'json'
        }).then(function (risk) {
            updateRisk(dataFromForm, aPrioriLookupData, risk);
        });
    }

    function updateRisk(dataFromForm, aPrioriLookupData, risk) {
        $('#resultsPanel').show();
        if (aPrioriLookupData) {
            console.log(aPrioriLookupData)
            $('#aPrioriManualResult').hide();
            $('#aPrioriLookupResult').show();
            $('#gestAgeResult').text(aPrioriLookupData.gaw + " weeks " + aPrioriLookupData.gad + " days");
            $('#matAgeResult').text(aPrioriLookupData.may + " years " + aPrioriLookupData.mam + " months");
            $('#trisomyTypeResult').text("T" + aPrioriLookupData.chrom);
        } else {
            $('#aPrioriManualResult').show();
            $('#aPrioriLookupResult').hide();
        }
        $('#trisomyChance').text(risk.risk + ' %');
        $('#llimResult').text(dataFromForm.lower + ' %');
        $('#ulimResult').text(dataFromForm.upper + ' %');
        $('#varcofResult').text(dataFromForm.varcof + ' %');
        $('#zscoreResult').text(dataFromForm.z);
        $('#aprioriResult').text(dataFromForm.aPriori + ' cases');
    }

    ///////// A priori risk lookup form //////////

    function getLookupFormData() {
        return {
            'chrom': $('input:radio[name=LookUpTrisomyTypeRadio]:checked').val(),
            'gaw': $('#gestAgeWeeks').val(),
            'gad': $('#gestAgeDays').val(),
            'may': $('#matAgeYears').val(),
            'mam': $('#matAgeMonths').val()
        };
    }

    function getAPrioriRisk() {
        var lookupFormData = getLookupFormData();
        $.ajax({
            type: 'GET',
            url: '/scripts/niptAPrioriRisk/run',
            data: lookupFormData,
            dataType: 'json'
        }).then(function (aPrioriRisk) {
            updateAPrioriRisk(lookupFormData, aPrioriRisk);
        });
    }

    function updateAPrioriRisk(lookupFormData, aPrioriRisk) {
        var $aPriori = $('#aPriori'),
            $mainPanel = $('#main-panel'),
            $lookup = $('#lookup');
        $mainPanel.collapse('toggle');
        $lookup.collapse('toggle');
        $aPriori.val(aPrioriRisk.aPriori);
        // remember the lookup form data used to compute this aPrioriRisk
        console.log('set');
        $aPriori.data('lookupFormData', lookupFormData);
        if (aPrioriRisk === "?") {
            $aPriori.attr('style', 'background-color:#d9534f');
        } else {
            $aPriori.attr('style', 'background-color:#dff0d8');
        }
    }

    function resetAPrioriLookupData() {
        $('#aPriori').data('lookupFormData', null);
    }

    ///////////  validation ///////////

    function validateGestationAge() {
        if (7 * 40 < 7 * parseFloat($('#gestAgeWeeks').val()) + parseFloat($('#gestAgeDays').val())) {
            $('#gestAge').show();
            return false;
        } else {
            $('#gestAge').hide();
            return true;
        }
    }

    function validateMaternalAge() {
        if (12 * 44 < 12 * parseFloat($('#matAgeYears').val()) + parseFloat($('#matAgeMonths').val())) {
            $('#matAge').show();
            return false;
        } else {
            $('#matAge').hide();
            return true;
        }
    }

    /////////// On Load ////////////

    $(function () {
        var $mainForm = $('#main-form'),
            $lookupForm = $('#lookup-form'),
            $calculateRiskBtn = $('#calculate-risk-btn'),
            $calculateAPrioriRiskBtn = $('#calculate-a-priori-risk-btn');

        $mainForm.validate();
        $lookupForm.validate();

        $('#aPriori').on('change keyup paste', resetAPrioriLookupData);

        $calculateRiskBtn.click(function (e) {
            e.preventDefault();
            e.stopPropagation();
            getRisk();
        });

        $calculateAPrioriRiskBtn.click(function (e) {
            e.preventDefault();
            e.stopPropagation();
            if (!validateGestationAge() || !validateMaternalAge()) {
                return;
            }
            getAPrioriRisk();
        });
    });
})($);
