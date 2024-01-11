module.exports = {
	extends: [ 'plugin:@wordpress/eslint-plugin/recommended' ],
	rules: {
		'prettier/prettier': 'warn',
		'no-undef': 'warn',
		'no-extra-semi': 'warn'
	},
	env: {
		es6: true,
		jquery: true,
		browser: true
	}
};
