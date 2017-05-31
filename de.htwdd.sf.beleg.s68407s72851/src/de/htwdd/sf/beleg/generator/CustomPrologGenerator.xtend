/*
 * generated by Xtext 2.11.0
 */
package de.htwdd.sf.beleg.generator

import de.htwdd.sf.beleg.customProlog.Atom
import de.htwdd.sf.beleg.customProlog.Clause
import de.htwdd.sf.beleg.customProlog.List
import de.htwdd.sf.beleg.customProlog.NonEmptyList
import de.htwdd.sf.beleg.customProlog.Predicate
import de.htwdd.sf.beleg.customProlog.Prologdsl
import de.htwdd.sf.beleg.customProlog.Query
import de.htwdd.sf.beleg.customProlog.Rule
import de.htwdd.sf.beleg.customProlog.Term
import java.util.LinkedList
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

	def transpileList(List l) {
		var ret = "("
		if (l === null) {
			ret += ")"
			return ret
		}

		if (l.nonempty !== null) {
			ret += "("
			ret += transpileNonEmptyList(l.nonempty)
			ret += ")"
		}
		ret += ")"
		return ret

	}

	def transpileNonEmptyList(NonEmptyList list) {
		var ret = "cons "
		if (list.atom !== null)
			ret += " " + list.atom.ident
		else if (list.folge !== null) {
			var stack = new LinkedList<Atom>
			var counter = 0
			stack.addAll(list.folge.atom)
			while (stack.isEmpty() != true) {
				counter++
				ret += "(cons " + stack.pop.ident + " "
				if (stack.size == 0)
					ret += "()"
			}
			for (var i = 0; i < counter; i++) {
				ret += ")"
			}
		}
		if (list.term !== null) {
			ret += " " + list.term.atom.ident + " "
		}
		if (list?.term?.list !== null)
			ret += list.term.list.transpileList

		return ret
	}

	def transpileTerm(Term term) {
		var ret = " "
		if (term.atom !== null)
			ret += term.atom.ident + " "
		else if (term.list !== null)
			ret += transpileList(term.list)
		return ret
	}

	def transpileClauses(EList<Clause> clauses) {
		var ret = ""
		ret += ''
		for (Clause c : clauses) {
			if (c.fact === null) {
				ret += c.rule.transpileRule
			}
			if (c.fact?.predicate !== null && c.fact !== null) {
				ret += '(' + transpilePredicates(c.fact.predicate) + ')\n' // fancy ? operator checks if fact is null :)
			}
		}
		ret += ')'
		return ret
	}

	def transpileRule(Rule rule) {
		var ret = "("
		ret += transpilePredicates(rule.rule)
		ret += transpileQuery(rule.query)
		ret += ')'
		return ret
	}

	def transpilePredicates(Predicate predicate) {
		var ret = ""
		if (predicate !== null && predicate.functor.funcName !== null) {
			ret += '(' + predicate.functor.funcName
			for (Term t : predicate?.term)
				ret += transpileTerm(t)
			// ret += ' ' + t?.atom?.ident ?: ""
			ret += ')'
		}
		return ret
	}

	def transpileQuery(Query q) {
		var ret = ""
		if (q !== null) {
			ret = ""
			for (p : q.p) {
				if (p !== null)
					ret += transpilePredicates(p)
			}
			ret += ''
		}
		return ret
	}

	def transpile(Prologdsl p) {
		var ret = '(prolog (quote '
		ret += '('
		ret += transpileClauses(p.program.clauses)
		ret += ')'
		ret += '\n'
		ret += '(quote (' + transpileQuery(p?.exquery.query)
		if (p.exquery !== null)
			ret += ')'
		ret += '))'
		return ret
	}
}
