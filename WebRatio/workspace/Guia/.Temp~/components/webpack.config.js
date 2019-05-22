
var path = require('path');

module.exports = {
	entry: "_wr_root",
	resolve: {
		root: [
			path.join(__dirname, "src"),
			
				"\/home\/matheus\/\u00C1rea de Trabalho\/1\u00BA Semestre 2019\/POC II\/WebRatioMobilePlatformCommunityEdition_8.10.3.Linux\/WebRatio\/plugins\/com.webratio.generator.mobile_8.10.3.201902120438\/BuiltinComponents\/src"
			,
				"\/home\/matheus\/\u00C1rea de Trabalho\/1\u00BA Semestre 2019\/POC II\/WebRatioMobilePlatformCommunityEdition_8.10.3.Linux\/WebRatio\/plugins\/com.webratio.components.mobile.content_8.10.3.201902120438\/src"
			
		]
	},
	module: {
		loaders: [{
			test: /\.js$/,
			exclude: [ /node_modules/ ],
			loader: "babel-loader",
			query: {
				whitelist: "es6.modules"
			}
		}]
	},
	resolveLoader: {
		root: [
			path.join("\/home\/matheus\/\u00C1rea de Trabalho\/1\u00BA Semestre 2019\/POC II\/WebRatioMobilePlatformCommunityEdition_8.10.3.Linux\/WebRatio\/Nodejs", "node_modules")
		]
	}
};
