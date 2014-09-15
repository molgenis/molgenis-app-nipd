<#include "nipd_macro.ftl">

<#include "molgenis-header.ftl">
<#include "molgenis-footer.ftl">

<#assign css=['nipd.css']>
<#assign js=['nipd.js']>

<@header css js/>

<div class="container">
	<div class="row">
		<a href="http://www.umcg.nl/NL/UMCG/Afdelingen/Genetica/Pages/default.aspx"><img src="img/umcg.png" /></a>
		<H1>Non-invasive prenatal testing</H1>
	</div>

	<div class="row">
		<div class="col-md-8 panel-group" id="parent-collapse">
		<div class="panel panel-primary">
			<div class="panel-heading">
				<h3 class="panel-title">Input</h3>
			</div>
			<div class="panel-body collapse in" id="main-panel">
				<form accept-charset="UTF-8" role="form" class="form-horizontal" id="main-form">
					<div class="form-group">
						<label class="col-md-4 control-label text-muted" for="llim">Lower limit fetal DNA</label>
						<div class="col-md-5">
							<div class="input-group">				
		                		<input id="llim" name="llim" class="form-control" type="text" value="1" data-rule-range="[0,100]" data-rule-number="true" data-msg-number="Please enter a value between 0 and 100%." data-msg-range="Please enter a value between 0 and 100%." required="required">
			                	<div class="input-group-addon">%</div>
			                </div>
		                </div>                
					</div>
					<div class="form-group">
						<label class="col-md-4 control-label text-muted" for="ulim">Upper limit fetal DNA</label>
						<div class="col-md-5">
							<div class="input-group">				
		                		<input id="ulim" name="ulim" class="form-control" type="text" value="30" data-rule-range="[0,100]" data-rule-number="true" data-msg-number="Please enter a value between 0 and 100%." data-msg-range="Please enter a value between 0 and 100%." required="required">
			                	<div class="input-group-addon">%</div>
			                </div>
		                </div>                
					</div>
					<div class="form-group">
						<label class="col-md-4 control-label text-muted" for="varcof">Variation coefficient</label>
						<div class="col-md-5">
							<div class="input-group">				
		                		<input id="varcov" name="varcof" class="form-control" type="text" value="0.5" data-rule-range="[0,100]" data-rule-number="true" data-msg-number="Please enter a value between 0 and 100." data-msg-range="Please enter a value between 0 and 100." required="required">
			                	<div class="input-group-addon">a.u.</div>
			                </div>
		                </div>                
					</div>
					<div class="form-group">
						<label class="col-md-4 control-label text-muted" for="zscore">Observed Z score</label>
						<div class="col-md-5">
							<div class="input-group">				
		                		<input id="zscore" name="zscore" class="form-control"  type="text" value="4" data-rule-range="[-5,40]" data-rule-number="true" data-msg-number="Please enter a value between -5 and 40." data-msg-range="Please enter a value between -5 and 40." required="required">
			                	<div class="input-group-addon">a.u.</div>
			                </div>
		                </div>                
					</div>
					<div class="form-group">
						<label class="col-md-4 control-label text-muted" for="aPriori">A priori risk</label>
						<div class="col-md-5">
							<div class="input-group">				
		                		<div class="input-group-addon">1 in</div>
		                		<input id="aPriori" name="aPriori" class="form-control"  type="text" data-rule-min="1" data-rule-digits="true" data-msg-digits="Please enter a whole number greater than or equal to 1." data-msg-min="Please enter a number greater than or equal to 1." required="required">
			                	<div class="input-group-addon">cases</div>
			                </div>
		                </div>
	                	<button type="button" class="btn btn-warning" data-toggle="collapse" data-target="#lookup" data-parent="#parent-collapse">Look up <span class="glyphicon glyphicon-list-alt"></span></button>
	                	<button id='calculate-risk-btn' type='submit' class='btn btn-primary'><b>Go</b> <span class="glyphicon glyphicon-chevron-right"></span></button>
					</div>
				</form>
			</div>

			<div id="lookup" class="collapse">			
				<div class="panel panel-warning">
					<div class="panel-heading" style="background-color:#FAD5A0">
						<h3 class="panel-title">Look up a priori risk</h3>
					</div>
					<div class="panel-body">
						<form accept-charset="UTF-8" role="form" class="form-horizontal" id="lookup-form">
							<div class="form-group">
								<label class="col-md-4 control-label text-muted" for="gestAgeWeeks">Gestational age</label>
								<div class="col-md-5">
									<div class="input-group">				
				                		<input id="gestAgeWeeks" name="gestAgeWeeks" class="form-control" type="text" value="20" data-rule-range="[10,40]" data-rule-digits="true" required="required"><div class="input-group-addon">weeks</div>
				                		<input id="gestAgeDays" name="gestAgeDays" class="form-control" type="text" value="0" data-rule-range="[0,6]" data-rule-digits="true" required="required"><div class="input-group-addon">days</div>
					                </div>
				                </div>                
							</div>
							<div class="form-group">
								<label class="col-md-4 control-label text-muted" for="matAgeYears">Maternal age</label>
								<div class="col-md-5">
									<div class="input-group">
										<input id="matAgeYears" name="matAgeYears"   class="form-control" type="text" value="20" data-rule-range="[20,44]" data-rule-digits="true" required="required"><div class="input-group-addon">years</div>
										<input id="matAgeMonths" name="matAgeMonths" class="form-control" type="text" value="0"  data-rule-range="[0,12]"  data-rule-digits="true" required="required"><div class="input-group-addon">months</div>
									</div>
				                </div>
							</div>
							<div class="form-group">
								<label class="col-md-4 control-label text-muted" for="matAgeYears">Maternal age</label>
								<div id="trisomyType" class="btn-group" data-toggle="buttons-radio">
									<div class="col-md-5">
										<button type="button" class="btn btn-default active" value="13">T13</button>
										<button type="button" class="btn btn-default" value="18">T18</button>
										<button type="button" class="btn btn-default" value="21">T21</button>
									</div>
								</div>
								<button class="btn btn-default" data-toggle="collapse" data-target="#main-panel" data-parent="#parent-collapse">Cancel</button>
								<button id="calculate-a-priori-risk-btn" type="submit" class="btn btn-warning"><b>Go</b> <span class="glyphicon glyphicon-chevron-right"></span></button>
							</div>
						</form>
					</div>
				</div>
			</div>
			<div style="clear:both"></div>
		</div>
		</div>
		<div class="col-md-4">
			<div class="panel panel-danger">
				<div class="panel-heading">
					<h3 class="panel-title">Result</h3>
				</div>
				<div class="panel-body">
					blaatdd
				</div>
			</div>
		</div>
	</div>




	<div class="row-fluid">
		<P CLASS="muted">Please see <a href="https://molgenis26.target.rug.nl/downloads/20140605_ppvfornipt_UserManual.pdf" target="_blank">user manual</a> or contact <a href="mailto:g.j.te.meerman@umcg.nl" target="_top">G.J. te Meerman</a> for further information.</P>
		<#--P CLASS="muted">A stand alone version of this software can be downloaded <a href="https://molgenis26.target.rug.nl/downloads/nipd_standalone.zip">here</a>.</P-->
	</div>	
</div>
<@footer/>