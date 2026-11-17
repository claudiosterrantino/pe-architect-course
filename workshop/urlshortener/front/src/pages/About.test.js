import { act, render, screen, waitFor } from "@testing-library/react";
import React from "react";
import About from "./About";
import Api from "../utils/api";

jest.mock("../utils/api", () => ({
  __esModule: true,
  default: {
    getServerStatus: jest.fn()
  }
}));

jest.mock("../components/Layout", () => ({ children }) => <>{children}</>);

test("keeps redirector status when backend health resolves later", async () => {
  let resolveServerStatus;
  Api.getServerStatus.mockImplementation(
    () => new Promise(resolve => {
      resolveServerStatus = resolve;
    })
  );
  global.fetch = jest.fn().mockResolvedValue({
    json: () => Promise.resolve({ redirector: true })
  });

  const { container } = render(<About />);

  await waitFor(() => {
    const alert = screen.getByText("Redirection Server Status").closest(".pf-c-alert");
    expect(alert).toHaveTextContent("Up and running");
  });

  await act(async () => {
    resolveServerStatus({ server: true, database: true });
  });

  const alert = screen.getByText("Redirection Server Status").closest(".pf-c-alert");
  expect(alert).toHaveTextContent("Up and running");
  expect(container).toHaveTextContent("Database Status");
});
