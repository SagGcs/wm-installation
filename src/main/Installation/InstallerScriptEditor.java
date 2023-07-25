import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.ListIterator;
import java.util.function.Consumer;

public class InstallerScriptEditor {
	protected List<String> edit(Path pScriptFile, List<String> pVariables) throws IOException {
		final List<String> lines = Files.readAllLines(pScriptFile, StandardCharsets.UTF_8);
		while (!pVariables.isEmpty()) {
			final String variableName = pVariables.remove(0);
			String variableValue = pVariables.remove(0);
			if (variableValue.startsWith("url(")  &&  variableValue.endsWith(")")) {
				final String urlUnencoded = variableValue.substring("url(".length(), variableValue.length()-1);
				variableValue = URLEncoder.encode(urlUnencoded, "UTF-8");
			} else if (variableValue.startsWith("urlVersion1(")  &&  variableValue.endsWith(")")) {
				final String urlVersionUnencoded =  variableValue.substring("urlVersion1(".length(), variableValue.length()-1);
				variableValue = "__VERSION1__," + URLEncoder.encode(urlVersionUnencoded);
			}
			final ListIterator<String> iter = lines.listIterator();
			boolean replaced = false;
			while (iter.hasNext()) {
				final String line = iter.next();
				if (line.startsWith(variableName + "=")) {
					iter.set(variableName + "=" + variableValue);
					replaced = true;
					break;
				}
			}
			if (!replaced) {
				throw new IllegalStateException("Variable " + variableName + " not found in input script:" + pScriptFile);
			}
		}
		return lines;
	}

	public static void main(String[] pArgs) throws Exception {
		final List<String> args = new ArrayList<>(Arrays.asList(pArgs));
		if (pArgs.length < 2) {
			throw usage(null);
		}
		final Path scriptFile = Paths.get(args.remove(0));
		if (!Files.isRegularFile(scriptFile)) {
			System.err.println("Script file not found: " + scriptFile);
			System.exit(1);
		}
		final String outFileStr = args.remove(0);
		final List<String> lines = new InstallerScriptEditor().edit(scriptFile, args);
		final Consumer<OutputStream> writer = (out) -> {
			final OutputStreamWriter osw = new OutputStreamWriter(out, StandardCharsets.UTF_8);
			final PrintWriter pw = new PrintWriter(osw);
			lines.forEach((s) -> pw.write(s + "\n"));
			pw.flush();
		};
		if ("-".equals(outFileStr)) {
			writer.accept(System.out);
		} else {
			final Path outFile = Paths.get(outFileStr);
			Files.createDirectories(outFile.getParent());
			try (OutputStream out = Files.newOutputStream(outFile)) {
				writer.accept(out);
			}
		}
	}

	public static RuntimeException usage(String pMsg) {
		if (pMsg != null) {
			System.err.println(pMsg);
			System.err.println();
		}
		System.err.println("Usage: java Replacer <InputScript> <OutputScript> [<Variable> <Value> ...]");
		System.exit(1);
		return null;
	}
}
