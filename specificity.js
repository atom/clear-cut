/**
 * Calculates the specificity of CSS selectors
 * http://www.w3.org/TR/css3-selectors/#specificity
 *
 * Returns a selector integer value
 */

// The following regular expressions assume that selectors matching the preceding regular expressions have been removed
var attributeRegex = /(\[[^\]]+\])/g;
var idRegex = /(#[^\s\+>~\.\[:]+)/g;
var classRegex = /(\.[^\s\+>~\.\[:]+)/g;
var pseudoElementRegex = /(::[^\s\+>~\.\[:]+|:first-line|:first-letter|:before|:after)/g;
var pseudoClassRegex = /(:[^\s\+>~\.\[:]+)/g;
var elementRegex = /([^\s\+>~\.\[:]+)/g;
var notRegex = /:not\(([^\)]*)\)/g;
var ruleRegex = /{[^]*/gm;
var separatorRegex = /[\*\s\+>~]/g;
var straysRegex = /[#\.]/g;

// Remove anything after a left brace in case a user has pasted in a rule, not just a selector
var removeRules = function(selector) {
	var matches = selector.match(ruleRegex);
	if (matches) {
		for (var i = 0; i < matches.length; i++) {
			selector = selector.replace(matches[i], ' ');
		}
	}

	return selector;
}

// Find matches for a regular expression in a string and push their details to parts
// Type is "a" for IDs, "b" for classes, attributes and pseudo-classes and "c" for elements and pseudo-elements
var findMatch = function(regex, type, typeCount, selector) {
	var matches = selector.match(regex);
	if (matches) {
		for (var i = 0; i < matches.length; i++) {
			typeCount[type]++;
			// Replace this simple selector with whitespace so it won't be counted in further simple selectors
			selector = selector.replace(matches[i], ' ');
		}
	}

	return selector;
}

var calculate = function(input) {
	// Separate input by commas
	var selectors = input.split(',');
	var results = [];

	for (var i = 0; i < selectors.length; i++) {
		if (selectors[i].length > 0) {
			results.push(calculateSingle(selectors[i]));
		}
	}

	return results;
};

// Calculate the specificity for a selector by dividing it into simple selectors and counting them
var calculateSingle = function(selector) {
	var	typeCount = {
		a: 0,
		b: 0,
		c: 0
	};

	// Remove the negation psuedo-class (:not) but leave its argument because specificity is calculated on its argument
	selector = selector.replace(notRegex, ' $1 ');

	selector = removeRules(selector);

	// Add attribute selectors to parts collection (type b)
	selector = findMatch(attributeRegex, 'b', typeCount, selector);

	// Add ID selectors to parts collection (type a)
	selector = findMatch(idRegex, 'a', typeCount, selector);

	// Add class selectors to parts collection (type b)
	selector = findMatch(classRegex, 'b', typeCount, selector);

	// Add pseudo-element selectors to parts collection (type c)
	selector = findMatch(pseudoElementRegex, 'c', typeCount, selector);

	// Add pseudo-class selectors to parts collection (type b)
	selector = findMatch(pseudoClassRegex, 'b', typeCount, selector);

	// Remove universal selector and separator characters
	selector = selector.replace(separatorRegex, ' ');

	// Remove any stray dots or hashes which aren't attached to words
	// These may be present if the user is live-editing this selector
	selector = selector.replace(straysRegex, ' ');

	// The only things left should be element selectors (type c)
	findMatch(elementRegex, 'c', typeCount, selector);

	return (typeCount.a * 100) + (typeCount.b * 10) + (typeCount.c * 1);
};

exports.calculate = calculate;
