/*
 * generated by Xtext 2.11.0
 */
package de.htwdd.sf.beleg.generator

import de.htwdd.sf.beleg.customProlog.Clause
import de.htwdd.sf.beleg.customProlog.Predicate
import de.htwdd.sf.beleg.customProlog.Prologdsl
import de.htwdd.sf.beleg.customProlog.Query
import de.htwdd.sf.beleg.customProlog.Rule
import de.htwdd.sf.beleg.customProlog.Term
import org.eclipse.emf.common.util.EList
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class CustomPrologGenerator extends AbstractGenerator {

	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		var text = ""
		for (e : resource.allContents.toIterable.filter(Prologdsl))
			text += e.transpile + " "
		text += "\n]"
		println(text)
		fsa.generateFile("prolog_s68407s72851.lsp", text)
	}

/*  Liste -- nicht Funktionsfähig
	
	def transplitFolge(Folge folge) {
		var ret = '(cons '
				
		if ( folge.atom.length() == 1 )
			ret += folge.atom.get(0) + '()'
			
		else
			ret += folge.atom.transplitRest
					
		ret += ')'
		
		return ret	
	}
	
	def transplitRest(EList<Atom> atom) {
		var ret = ""
		var i = 0
		if ( atom === null )
			ret += '()'
		else {
			for (; atom !== null ; i++) {
				ret += '(cons' + atom.last()
				atom.remove(atom.last())
			}
			
			ret += '()'
			
			for (; i > 0 ; i--) {
				ret += ')'
			}
			
		}
		
		return ret
	}
	
	def transplitList(List list) {
		var ret = ""
		
		if ( list === null )
			ret += '()'
		else {
			ret += list.list.transplitNonEmptyList
		}
			
		return ret
	}
	
	def transplitNonEmptyList(NonEmptyList nonemptylist) {
		var ret = ""
		
		if ( nonemptylist.folge !== null )
			ret += nonemptylist.folge.transplitFolge
		else {
			ret += nonemptylist?.atom?.ident ?: ""
		}
		
		return ret
	}
*/
	def transpileClauses(EList<Clause> clauses) {
		var ret = ""
		ret += '('
		for (Clause c : clauses) {
			if (c.fact?.predicate !== null) {
				ret += '(' + transpilePredicates(c?.fact?.predicate) + ')\n' ?: "" // fancy ? operator checks if fact is null :)
			}
			if (c.rule !== null) {
				ret += "("
				ret += c.rule.transpileRule
				ret += ")"
			}
		}
		ret += ")"
		return ret
	}

	def transpileRule(Rule rule) {
		var ret = ""
		ret += transpilePredicates(rule.rule)
		ret += transpileQuery(rule.query)
		ret += ''
		return ret
	}

	def transpilePredicates(Predicate predicate) {
		var ret = ""
		if (predicate !== null && predicate.functor.funcName !== null) {
			ret += '(' + predicate?.functor.funcName + ' ' ?: ""
			for (Term t : predicate?.term)
				ret += ' ' + t?.atom?.ident ?: ""
			ret += ')'
		}
		return ret
	}

	def transpileQuery(Query q) {
		var ret = "("
		for (p : q.p) {
			if (p !== null)
				ret += transpilePredicates(p)
		}
		ret += ')'
		return ret
	}

	def transpile(Prologdsl p) {
		var ret = '(prolog (quote '
		ret += transpileClauses(p.program.clauses)
		ret += '\n'
		ret += '(quote ' + transpileQuery(p?.exquery.query)
		ret += '))'
		return ret
	}
}
